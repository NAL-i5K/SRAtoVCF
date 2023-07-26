cwlVersion: v1.0
class: CommandLineTool
doc: |-
  Downlaod the bioproject metadat related to the species name that input.
requirements:
  ShellCommandRequirement: {}
  InitialWorkDirRequirement:
    listing:
    - entryname: download_bioproject_metadata.sh
      entry: |-
        bp_ids=$(esearch -db bioproject -query "$(inputs.species_name)[Organism]" | efetch -format docsum | xtract -pattern DocumentSummary -element  Project_Acc)
        for bp_id in $bp_ids; do
          sra_data=$(esearch -db sra -query "$bp_id" | efetch -format runinfo | grep -E "WGS.*GENOMIC.*PAIRED.*ILLUMINA.*$(inputs.species_name)")
          sra_accession=$(echo "$sra_data" | cut -d ',' -f 1 | paste -sd "/" -)
          sra_files=$(echo "$sra_data" | cut -d ',' -f 1,5 | tr ',' '/')
          num_files=$(echo "$sra_files" | grep -v '^$' | wc -l)
          total_size=$(echo "$sra_files" | awk -F'/' '{ sum += $2 } END { print sum }')
          total_size_gb=$(echo "scale=2; $total_size / (1000*1000*1000)" | bc)
          if [ $num_files -ne 0 ]; then
            pubmed_dat=$(esearch -db bioproject -query "$bp_id"| elink -target pubmed| efetch -format docsum |xtract -pattern DocumentSummary -element Id,Title)
            pubmed_ids=$(echo "$pubmed_dat" | cut -f 1 | paste -sd "/" -)
            pubmed_titles=$(echo "$pubmed_dat" | cut -f 2 | paste -sd "/" -)
            echo "$bp_id\t$pubmed_ids\t$pubmed_titles\t$sra_accession\t$num_files\t$total_size_gb" >> "$(inputs.output_file)"
          fi
        done       
inputs:
  species_name:
    type: string
    doc: |-
      The species name wants to search. 
  output_file:
    type: string
    doc: |-
      Name of the output file that will be created.
arguments:
    - shellQuote: false
      valueFrom: |-
        python download_bioproject_metadata.py "$(inputs.species_name)" "$(inputs.output_file)"
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file)
    doc: |-
      Output file matching the name specified in the "output_file" input.
