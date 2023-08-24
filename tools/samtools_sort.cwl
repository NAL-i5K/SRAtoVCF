cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: staphb/samtools:1.17-2023-06

baseCommand: [samtools, sort]

inputs:
  input:
    type: File
    inputBinding:
      position: 1
  threads:
    type: int?
    default: 1
    inputBinding:
      prefix: '-@'
  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: '-o'
  output_format:
    type: string
    default: "BAM"
    inputBinding:
      position: 3
      prefix: '-O'

outputs:
  sorted:
    type: File
    outputBinding:
      glob: $(inputs.output_name)


