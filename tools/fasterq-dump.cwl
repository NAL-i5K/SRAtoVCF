cwlVersion: v1.2
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: ncbi/sra-tools:latest


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