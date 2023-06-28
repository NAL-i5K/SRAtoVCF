cwlVersion: v1.0
class: CommandLineTool
doc: |-
  Downlaod the bioproject metadat related to the species name that input.
requirements:
  ShellCommandRequirement: {}
  InitialWorkDirRequirement:
    listing:
    - entryname: download_bioproject_metadata.py
      entry: |-
        from sys import argv
        import os
        import subprocess
        species_name = argv[1]
        output_file_name = argv[2]

        query = f"{species_name}[Organism]"
        bp_ids_cmd = f"esearch -db bioproject -query '{query}' | efetch -format docsum | xtract -pattern DocumentSummary -element Project_Acc"
        bp_ids_proc = subprocess.Popen(bp_ids_cmd, stdout=subprocess.PIPE, shell=True)
        bp_ids = bp_ids_proc.communicate()[0].decode("utf-8").strip().split() 

        with open(output_file_name, "w") as output_file:
            output_file.write("BioProject ID\tRelated PubMed IDs\tRelated PubMed Titles\tRelated SRA Files\tNumber of Files\tTotal Size (GB)\n")
            for bp_id in bp_ids:
                # Find related SRA files
                sra_data_cmd = f"esearch -db sra -query '{bp_id}' | efetch -format runinfo | grep -E 'WGS.*GENOMIC.*PAIRED.*ILLUMINA.*{species_name}'"
                sra_data_proc = subprocess.Popen(sra_data_cmd, stdout=subprocess.PIPE, shell=True)
                sra_data = sra_data_proc.communicate()[0].decode("utf-8").strip()
                if len(sra_data) !=0:
                    sra_accession = "/".join([x.split(",")[0] for x in sra_data.split("\n") if x.strip()])
                    sra_files_size =  [x.strip().split(",")[4] for x in sra_data.split("\n") if x.strip()]
                    num_files = len(sra_accession.split('/'))
                    total_size_gb = round(sum(map(int,sra_files_size))/ (1000*1000*1000),2)
                    # Find related PubMed IDs
                    pubmed_dat_cmd = f"esearch -db bioproject -query '{bp_id}' | elink -target pubmed | efetch -format docsum | xtract -pattern DocumentSummary -element Id,Title"
                    pubmed_dat_proc = subprocess.Popen(pubmed_dat_cmd, stdout=subprocess.PIPE, shell=True)
                    pubmed_dat = pubmed_dat_proc.communicate()[0].decode("utf-8").strip()
                    if len(pubmed_dat) !=0:
                        pubmed_ids = "/".join([x.split("\t")[0] for x in pubmed_dat.split("\n") if x.strip()])
                        pubmed_titles = "/".join([x.split("\t")[1] for x in pubmed_dat.split("\n") if x.strip()])
                    else:
                        pubmed_ids = ""
                        pubmed_titles = ""
                    # Output results to file
                    output_file.write(f"{bp_id}\t{pubmed_ids}\t{pubmed_titles}\t{sra_accession}\t{num_files}\t{total_size_gb}\n")          
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
