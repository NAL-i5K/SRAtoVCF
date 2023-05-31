cwlVersion: v1.2
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: ncbi/sra-tools

inputs:
  accession:
    type: string
    inputBinding:
      position: 1
  transport:
    type: string?
    inputBinding:
      position: 2
      prefix: '-t'
  output_path:
    type: string?
    default: "." 
    inputBinding:
      position: 3
      prefix: '-O'
  

outputs:
   sra_file:
    type: File
    outputBinding:
      glob: $(inputs.accession)/$(inputs.accession).sra


baseCommand: [prefetch]