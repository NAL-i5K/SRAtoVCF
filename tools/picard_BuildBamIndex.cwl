cwlVersion: v1.2
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
      dockerPull: broadinstitute/gatk:latest

inputs:
    input:
        type: File
        inputBinding:
            position: 3
            separate: false
            prefix: INPUT=
        doc: INPUT String A BAM file or URL to process. Must be sorted in coordinate order.
    output_filename:
        type: string
        inputBinding:
            position: 4
            separate: false
            prefix: OUTPUT=

outputs:
  index:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: gatk
arguments:
- valueFrom: BuildBamIndex
  position: 2