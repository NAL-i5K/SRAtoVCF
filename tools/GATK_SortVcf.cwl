cwlVersion: v1.0
class: CommandLineTool

requirements:
    InlineJavascriptRequirement: {}
    ResourceRequirement:
      ramMin: 1024
hints:
    DockerRequirement:
      dockerPull: broadinstitute/gatk:4.4.0.0
 
baseCommand: [gatk, SortVcf]

inputs:
  vcf_file_SNP:
    type: File
    inputBinding:
      position: 3
      prefix: '-I'
  vcf_file_INDEL:
    type: File
    inputBinding:
      position: 4
      prefix: '-I'
  output:
    type: string
    inputBinding:
      position: 5
      prefix: '-O'
  

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.output)
