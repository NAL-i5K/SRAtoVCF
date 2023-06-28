cwlVersion: v1.0
class: CommandLineTool

requirements:
    InlineJavascriptRequirement: {}
    ResourceRequirement:
      ramMin: 1024
hints:
    DockerRequirement:
      dockerPull: broadinstitute/gatk:latest
 
baseCommand: [gatk, VariantFiltration]

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
  filter_expression:
    type: string
    default: "QD < 5.0 || FS > 50.0 || SOR > 3.0 || MQ < 50.0 || MQRankSum < -2.5 || ReadPosRankSum < -1.0 || ReadPosRankSum > 3.5"
    inputBinding:
      position: 5
      prefix: '--filter-expression'
  filter_name: 
    type: string
    default: "my_filter" 
    inputBinding:
      position: 6
      prefix: '--filter-name' 
  output:
    type: string
    inputBinding:
      position: 7
      prefix: '--output'
  

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - .tbi

