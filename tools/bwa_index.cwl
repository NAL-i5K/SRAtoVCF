cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.ref_genome) ]
hints:
  DockerRequirement:
    dockerPull: staphb/bwa:latest
 
inputs:
  ref_genome:
    type: File

baseCommand: [bwa, index]

arguments:
  - valueFrom: $(inputs.ref_genome.path)
    position: 1
      
outputs:
  index_bwa_amb:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).amb
  index_bwa_ann:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).ann
  index_bwa_bwt:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).bwt
  index_bwa_pac:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).pac
  index_bwa_sa:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).sa