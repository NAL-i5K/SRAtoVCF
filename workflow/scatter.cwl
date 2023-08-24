cwlVersion: v1.0
class: Workflow

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
    ref_genome:
        type: File
        secondaryFiles:
            - .amb
            - .ann
            - .bwt
            - .pac
            - .sa
            - .fai
            - ^.dict  
    SRA_accession:
        type: string[] 
    input_adapters_file:
        type: File
    removeDuplicates:  
        type: string
    ReadGroupID: 
        type: string
    ReadGroupLibrary:
        type: string
    ReadGroupPlatform:
        type: string
    ReadGroupPlatformUnit:
        type: string
    ReadGroupSampleName: 
        type: string
    CREATE_INDEX:
        type: string
    creat_variant_index:
        type: boolean
    select_type_INDEL:
        type: string
    filter_expression_SNP:
        type: string
    filter_expression_INDEL:
        type: string
    exclude_filtered:
        type: string
    creat_index: 
        type: string


steps:
    get_vcf_files:
        run: ../workflow/main.cwl
        scatter: SRA_accession
        in:
            ref_genome: ref_genome
            SRA_accession: SRA_accession
            input_adapters_file: input_adapters_file
            removeDuplicates: removeDuplicates
            ReadGroupID: ReadGroupID
            ReadGroupLibrary: ReadGroupLibrary
            ReadGroupPlatform: ReadGroupPlatform
            ReadGroupPlatformUnit: ReadGroupPlatformUnit
            ReadGroupSampleName: ReadGroupSampleName 
            CREATE_INDEX: CREATE_INDEX
            creat_variant_index: creat_variant_index
            select_type_INDEL: select_type_INDEL
            filter_expression_SNP: filter_expression_SNP
            filter_expression_INDEL: filter_expression_INDEL
            exclude_filtered: exclude_filtered
            creat_index: creat_index
        out: [vcf]
outputs:
    vcf_file:
      type: File[]
      outputSource: get_vcf_files/vcf
