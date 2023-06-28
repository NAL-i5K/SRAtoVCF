cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.ref_genome)
      - entry: $(inputs.ref_bwa_amb)
      - entry: $(inputs.ref_bwa_ann)
      - entry: $(inputs.ref_bwa_bwt)
      - entry: $(inputs.ref_bwa_pac)
      - entry: $(inputs.ref_bwa_sa)
      - entry: $(inputs.ref_sam)
      - entry: $(inputs.ref_picard)
     
 
inputs:
  ref_genome:
    type: File
  ref_bwa_amb:
    type: File
  ref_bwa_ann:
    type: File
  ref_bwa_bwt:
    type: File
  ref_bwa_pac:
    type: File
  ref_bwa_sa:
    type: File
  ref_sam:
    type: File
  ref_picard:
    type: File

baseCommand: [echo, 'merging']
   
outputs:
  index_ref: 
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
    outputBinding:
      glob: $(inputs.ref_genome.basename)