cwlVersion: v1.0
class: Workflow


requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.ref_genome) ]
  MultipleInputFeatureRequirement: {}
 
inputs:
  ref_genome:
    type: File

steps:
    bwa:
        run: ../tools/bwa_index.cwl
        in: 
          ref_genome: ref_genome
        out: [index_bwa_amb, index_bwa_ann,index_bwa_bwt, index_bwa_pac, index_bwa_0123 ]
    samtools:
        run: ../tools/samtools_faidx.cwl
        in: 
          ref_genome: ref_genome
        out: [index_sam]
    picard:
        run: ../tools/picard_CreateSequenceDictionary.cwl
        in: 
          ref_genome: ref_genome
        out: [index_picard]
    merge:
        run: ../tools/merge_ref.cwl
        in:
          ref_genome: ref_genome
          ref_bwa_amb:
            source: bwa/index_bwa_amb
          ref_bwa_ann: 
            source: bwa/index_bwa_ann
          ref_bwa_bwt: 
            source: bwa/index_bwa_bwt
          ref_bwa_pac: 
            source: bwa/index_bwa_pac
          ref_bwa_0123: 
            source: bwa/index_bwa_0123
          ref_sam: 
            source: samtools/index_sam
          ref_picard: 
            source: picard/index_picard
        out: [index_ref]
   
      
outputs:
  index_ref:
    type: File
    outputSource: merge/index_ref
     
