cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: ncbi/sra-tools:3.0.1


inputs:
  fasta:
    type: boolean?
    default: false
    inputBinding: 
      position: 2
      prefix: '--fasta'
  gzip:
    type: boolean?
    default: true 
    inputBinding:
      position: 3
      prefix: '--gzip'
  split-files:
    type: boolean?
    default: true 
    inputBinding:
      position: 4
      prefix: '--split-files'
  
 
outputs:
  fastqFiles:
    type: File[]
    outputBinding:
      glob: "*fastq*"
  forward:
    type: File?
    outputBinding:
      glob: "*_1.fastq*"
  reverse:
    type: File?
    outputBinding:
      glob: "*_2.fastq*"

baseCommand: [fasterq-dump]