cwlVersion: v1.2
class: CommandLineTool


requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
      dockerPull: broadinstitute/gatk:latest
 
inputs:
  ref_genome:
    type: File

baseCommand:
- gatk
- CreateSequenceDictionary

arguments:
  - valueFrom: $(inputs.ref_genome.path)
    position: 1
    prefix: -R
  
      
outputs:
  index_picard:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.nameroot).dict