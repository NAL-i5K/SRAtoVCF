cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: staphb/fastqc:latest

baseCommand: [fastqc]
inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
  threads:
    type: int?
    default: 1
    inputBinding:
      prefix: '-t'
  outdir:
    type: string
    default: .
    inputBinding:
      prefix: --outdir
outputs:
  report_html:
    type: File
    outputBinding:
      glob: "*.html"
  report_zip:
    type: File
    outputBinding:
      glob: "*.zip"
stdout: fastqc.log
