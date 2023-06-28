cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.ref_genome) ]
hints:
  DockerRequirement:
    dockerPull: staphb/samtools:latest
 
baseCommand: [samtools, faidx]

inputs:
  ref_genome:
    type: File

arguments:
  - valueFrom: $(inputs.ref_genome.path)
    position: 1
      
outputs:
  index_sam:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).fai