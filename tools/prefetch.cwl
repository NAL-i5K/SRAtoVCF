cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: ncbi/sra-tools:3.0.1

baseCommand: [prefetch]

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


