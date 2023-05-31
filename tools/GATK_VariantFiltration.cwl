cwlVersion: v1.2
class: CommandLineTool


requirements:
    InlineJavascriptRequirement: {}
    DockerRequirement:
      dockerPull: broadinstitute/gatk:latest
 


baseCommand: [ gatk, VariantFiltration ]

inputs:
  vcf_file:
    type: File
    inputBinding:
      prefix: --variant
    secondaryFiles:
      - .tbi
  reference:
    type: File
    inputBinding:
      prefix: --reference
    secondaryFiles:
      - .fai
      - ^.dict
  output:
    type: string
    default: filter.vcf.gz
    inputBinding:
      prefix: --output
  
  filter_expression:
    type: string
    default: "QD < 5.0 || FS > 50.0 || SOR > 3.0 || MQ < 50.0 || MQRankSum < -2.5 || ReadPosRankSum < -1.0 || ReadPosRankSum > 3.5"
    inputBinding:
      prefix: --filter-expression
  filter_name: 
    type: string
    default: "my_filter" 
    inputBinding:
      prefix: --filter-name 

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - .tbi