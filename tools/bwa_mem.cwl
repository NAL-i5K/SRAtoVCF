cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement
    coresMin: $(inputs.threads)
hints:
  DockerRequirement:
    dockerPull: staphb/bwa:latest

inputs:
  reference:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
    inputBinding:
      position: 1

  output_filename: 
    type: string
  read_F:
    type: File
    inputBinding:
      position: 2
  read_R:
    type: File
    inputBinding:
      position: 3
  threads:
    default: 1
    type: int?
    inputBinding:
      position: 4
      prefix: -t


 
stdout: $(inputs.output_filename)

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [bwa, mem]

