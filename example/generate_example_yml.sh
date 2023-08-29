#!/bin/bash

# Take user input path
read -p "Enter git clone path: " git_clone_path

content="ref_genome:
  class: File
  path: $git_clone_path/SRAtoVCF/data/GCF_000146045.2_R64_genomic.fna
SRA_accession: SRR23631020
input_adapters_file:
  class: File
  path: $git_clone_path/SRAtoVCF/adapters/TruSeq3-PE.fa
removeDuplicates: 'TRUE'
ReadGroupID: \"1\"
ReadGroupLibrary: lib1
ReadGroupPlatformUnit: \"unit1\"
ReadGroupPlatform: ILLUMINA
ReadGroupSampleName: \"1\"
CREATE_INDEX: \"TRUE\"
creat_variant_index: TRUE
select_type_INDEL: \"INDEL\"
filter_expression_SNP: \"QD < 2.0 || FS > 60.0 || SOR > 3.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || QUAL < 30.0\"
filter_expression_INDEL: \"QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || QUAL < 30.0 \"
exclude_filtered: \"TRUE\"
creat_index: \"TRUE\""

output_file="example.yaml"

echo "$content" > "$output_file"

echo "File generated: $output_file"
