cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: staphb/samtools:latest

inputs:
  input:
    type: File
    inputBinding:
      position: 1

  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: -o
outputs:
  index:
    type: File
    secondaryFiles:
            - .tbi
    outputBinding:
      glob: $(inputs.output_name)

baseCommand: [samtools, tabix]