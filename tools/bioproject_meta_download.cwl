cwlVersion: v1.0
class: CommandLineTool
doc: |-
  Downlaod the bioproject metadat related to the species name that input.
requirements:
  ShellCommandRequirement: {}
hints:
  DockerRequirement:
    dockerPull: ncbi/edirect:latest

baseCommand: [bash]

inputs: 
  script: 
    type: File
    inputBinding:
      position: 1
    default:
        class: File
        basename: "script.sh"
        contents: |-
          species_name=$1
          output_file=$2
          bp_ids=$(esearch -db bioproject -query "$species_name[Organism]" | efetch -format docsum | xtract -pattern DocumentSummary -element  Project_Acc)
          echo -e "BioProject ID\tRelated PubMed IDs\tRelated PubMed Titles\tRelated SRA Files\tPlatform\tNumber of Files\tTotal Size (GB)" > "$output_file"
          for bp_id in $bp_ids; do
            sra_data=$(esearch -db sra -query "$bp_id" | efetch -format runinfo | grep -E "WGS.*GENOMIC.*PAIRED.*ILLUMINA.")
            sra_accession=$(echo "$sra_data" | cut -d ',' -f 1 | paste -sd "/" -)
            sra_platform=$(echo "$sra_data" | cut -d ',' -f 20 | paste -sd "/" -)
            sra_files=$(echo "$sra_data" | cut -d ',' -f 5 )
            num_files=$(echo "$sra_data" | grep -v '^$' | wc -l)
            total_size_gb=$( echo "$sra_files" | awk '{ sum += $1 } END { gb = sum / 1000000000; printf "%.2f", gb }')

            pubmed_dat=$(esearch -db bioproject -query "$bp_id"| elink -target pubmed| efetch -format docsum |xtract -pattern DocumentSummary -element Id,Title)

            if [ -n "$pubmed_dat" ]; then
              pubmed_ids=$(echo "$pubmed_dat" | cut -f 1 | paste -sd "/" -)
              pubmed_titles=$(echo "$pubmed_dat" | cut -f 2 | paste -sd "/" -)
            else
              pubmed_ids=""
              pubmed_titles=""
            fi
            if [ $num_files -ne 0 ]; then
              echo -e "$bp_id\t$pubmed_ids\t$pubmed_titles\t$sra_accession\t$sra_platform\t$num_files\t$total_size_gb" >> "$output_file"
            fi
          done  


  species_name:
    type: string
    inputBinding:
      position: 2
    doc: |-
      The species name wants to search. 
  output_file:
    type: string
    inputBinding:
      position: 3
    doc: |-
      Name of the output file that will be created.

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file)
    doc: |-
      Output file matching the name specified in the "output_file" input.
 