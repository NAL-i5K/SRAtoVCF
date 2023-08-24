cwlVersion: v1.0
class: CommandLineTool

requirements:
    InlineJavascriptRequirement: {}
    ResourceRequirement:
      ramMin: 1024
hints:
    DockerRequirement:
      dockerPull: broadinstitute/gatk:4.4.0.0
 
baseCommand: [gatk, SelectVariants]

inputs:
  reference:
    type: File
    inputBinding:
      position: 3
      prefix: '--reference'
    secondaryFiles:
      - .fai
      - ^.dict
  vcf_file:
    type: File
    inputBinding:
      position: 4
      prefix: '--variant'
    secondaryFiles:
      - .tbi
  exclude_filtered:
    type: string?
    default: "FALSE"
    inputBinding:
      position: 5
      prefix: '--exclude-filtered'
  select_type: 
    type: string?
    default: "SNP"
    inputBinding:
      position: 1
      prefix: '--select-type-to-include' 
  creat_index: 
    type: string?
    default: "TRUE" 
    inputBinding:
      position: 9
      prefix: '--create-output-variant-index' 
  output:
    type: string
    inputBinding:
      position: 10
      prefix: '--output'
  

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - .tbi
  