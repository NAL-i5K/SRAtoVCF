cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: biocontainers/vcftools:latest

baseCommand: [vcftools]

inputs:
    vcf_file:
        type: File
        inputBinding:
            position: 2
            prefix: '--vcf'
    keep_only_indels:
        default: false
        type: boolean?
            inputBinding:
            prefix: '--keep-only-indels'
            position: 3
    remove_indels:
        default: true
        type: boolean?
            inputBinding:
            prefix: '--remove-indels'
            position: 3
    recode:
        default: true
        type: boolean?
            inputBinding:
            prefix: '--recode'
            position: 4
    recode_INFO_all:
        default: true
        type: boolean?
            inputBinding:
            prefix: '--recode-INFO-all'
            position: 5
    output_name:
        type: string
            inputBinding:
            prefix: '--out'
            position: 6

outputs:
  select_vcf:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

