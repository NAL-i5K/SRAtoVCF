cwlVersion: v1.2
class: CommandLineTool


requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.ref_genome) ]
  DockerRequirement:
    dockerPull: staphb/samtools:latest
 
inputs:
  ref_genome:
    type: File

baseCommand:
- samtools
- faidx

arguments:
  - valueFrom: $(inputs.ref_genome.path)
    position: 1
      
outputs:
  index_sam:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).fai