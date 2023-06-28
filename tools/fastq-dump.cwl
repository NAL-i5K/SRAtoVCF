cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: ncbi/sra-tools:latest


inputs:
  fasta:
    type: boolean?
    default: false
    inputBinding: 
      position: 2
      prefix: '--fasta'
  SRA_file:
    type: File
    inputBinding:
      position: 1
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
  origfmt:
    default: false
    type: boolean?
    inputBinding:
      position: 5
      prefix: '--origfmt'

  
 
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

baseCommand: [fastq-dump]


