cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.ref_genome) ]
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/bwa-mem2:2.2.1--hd03093a_5"
 
inputs:
  ref_genome:
    type: File

baseCommand: [bwa-mem2, index]

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
      glob: $(inputs.ref_genome.basename).bwt.2bit.64
  index_bwa_pac:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).pac
  index_bwa_0123:
    type: File
    outputBinding:
      glob: $(inputs.ref_genome.basename).0123
