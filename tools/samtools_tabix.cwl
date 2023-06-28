cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: staphb/samtools:latest

baseCommand: [samtools, tabix]

inputs:
  input:
    type: File
    inputBinding:
      position: 1

  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: '-o'
outputs:
  index:
    type: File
    secondaryFiles:
            - .tbi
    outputBinding:
      glob: $(inputs.output_name)

