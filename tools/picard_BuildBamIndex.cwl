cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
      dockerPull: broadinstitute/gatk:4.4.0.0

inputs:
    input:
        type: File
        inputBinding:
            position: 3
            separate: false
            prefix: '-I'
    output_filename:
        type: string
        inputBinding:
            position: 4
            separate: false
            prefix: '-O'

outputs:
  index:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [gatk, BuildBamIndex]
