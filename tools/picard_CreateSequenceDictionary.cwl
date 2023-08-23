cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
      dockerPull: broadinstitute/gatk:4.4.0.0
 
inputs:
  ref_genome:
    type: File

baseCommand: [gatk, CreateSequenceDictionary]

arguments:
  - valueFrom: $(inputs.ref_genome.path)
    position: 1
    prefix: '-R'
  
      
outputs:
  index_picard:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.nameroot).dict