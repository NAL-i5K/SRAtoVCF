cwlVersion: v1.0
class: Workflow

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
    ref_genome:
        type: File
        secondaryFiles:
            - .amb
            - .ann
            - .bwt.2bit.64
            - .pac
            - '.0123'
            - .fai
            - ^.dict  
    SRA_accession:
        type: string 
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
    get_sra_file:
        run: ../tools/prefetch.cwl
        in: 
            accession: SRA_accession
        out: [sra_file]
    download_sra_file:
        run: ../tools/fastq-dump.cwl
        in: 
            SRA_file: 
                source: get_sra_file/sra_file
        out: [forward, reverse]
    Trimmomatic:
        run: ../tools/trimmomatic.cwl
        in:
            log_filename: SRA_accession
            R1_fastq_file: 
                source: download_sra_file/forward
            R2_fastq_file: 
                source: download_sra_file/reverse
            input_adapters_file: input_adapters_file
        out: [log_file,R1_trimmed_paired_file,R1_trimmed_unpaired_file,R2_trimmed_paired_file,R2_trimmed_unpaired_file]
    FastQC_F:
        run: ../tools/fastqc.cwl
        in:
            input_file: 
                source: Trimmomatic/R1_trimmed_paired_file
        out: [report_html, report_zip]
    FastQC_R:
        run: ../tools/fastqc.cwl
        in:
            input_file: 
                source: Trimmomatic/R2_trimmed_paired_file
        out: [report_html, report_zip]
    BWA_mem:
        run: ../tools/bwa_mem.cwl
        in:
            reference: 
                source: ref_genome
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + ".sam"}
            read_F:
                source: Trimmomatic/R1_trimmed_paired_file
            read_R:
                source: Trimmomatic/R2_trimmed_paired_file
        out: [output]
    Sort_sam:
        run: ../tools/samtools_sort.cwl
        in:
            input: 
                source: BWA_mem/output
            output_name: 
                source: SRA_accession
                valueFrom: ${ return self + ".bam"}
        out: [sorted]
    Picard_MarkDuplicates:
        run: ../tools/picard_MarkDuplicates.cwl
        in:
            input_files: 
                source: Sort_sam/sorted
            metricsFile:
                source: SRA_accession
                valueFrom: ${ return self + "_metrics.txt"}
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + ".markdup.bam"}
            removeDuplicates: removeDuplicates 
        out: [markDups_output]
    Picard_AddOrReplacereadGroup:
        run: ../tools/picard_AddOrReplaceReadGroups.cwl
        in:
            input: 
                source: Picard_MarkDuplicates/markDups_output
            output: 
                source: SRA_accession
                valueFrom: ${ return self + ".RG.markdup.bam"}
            ReadGroupID: ReadGroupID
            ReadGroupLibrary: ReadGroupLibrary
            ReadGroupPlatform: ReadGroupPlatform
            ReadGroupPlatformUnit: ReadGroupPlatformUnit
            ReadGroupSampleName: ReadGroupSampleName
            CREATE_INDEX: CREATE_INDEX
        out: [out_bam]
    GATK_HaplotypeCaller:
        run: ../tools/GATK_Haplotypecaller.cwl
        in:
            input_bamfile:  
                source: Picard_AddOrReplacereadGroup/out_bam
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + ".vcf.gz"}
            reference: 
                source: ref_genome
            bam_output: 
                source: SRA_accession
                valueFrom: ${ return self + "_haplotype.bam"}
            creat_variant_index: creat_variant_index
        out: [output_file,output_file_bam]
    GATK_SelectVariants_SNP:
        run: ../tools/GATK_SelectVariants.cwl
        in:
            vcf_file: 
                source: GATK_HaplotypeCaller/output_file
            reference: 
                source: ref_genome
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_SNP.vcf.gz"}
        out: [vcf]
    GATK_SelectVariants_INDEL:
        run: ../tools/GATK_SelectVariants.cwl
        in:
            vcf_file: 
                source: GATK_HaplotypeCaller/output_file
            reference: 
                source: ref_genome
            select_type: select_type_INDEL
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_INDEL.vcf.gz"}
        out: [vcf]
    GATK_VariantFiltration_SNP:
        run: ../tools/GATK_VariantFiltration.cwl
        in:
            vcf_file: 
                source: GATK_SelectVariants_SNP/vcf
            reference: 
                source: ref_genome
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_SNP_filter.vcf.gz"}
            filter_expression: filter_expression_SNP
        out: [vcf]
    GATK_VariantFiltration_INDEL:
        run: ../tools/GATK_VariantFiltration.cwl
        in:
            vcf_file: 
                source: GATK_SelectVariants_INDEL/vcf
            reference: 
                source: ref_genome
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_INDEL_filter.vcf.gz"}
            filter_expression: filter_expression_INDEL
        out: [vcf]
    GATK_SortVcf:
        run: ../tools/GATK_SortVcf.cwl
        in:
            vcf_file_SNP: 
                source: GATK_VariantFiltration_SNP/vcf
            vcf_file_INDEL: 
                source: GATK_VariantFiltration_INDEL/vcf
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_sort.vcf.gz"}
        out: [vcf]
    GATK_SelectVariants:
        run: ../tools/GATK_SelectVariants.cwl
        in:
            vcf_file: 
                source:  GATK_SortVcf/vcf
            reference: 
                source: ref_genome
            exclude_filtered: exclude_filtered
            creat_index: creat_index
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_filtered.vcf.gz"}
        out: [vcf, vcf_tbi]

outputs:
    vcf:
        type: File
        outputSource: GATK_SelectVariants/vcf
    vcf_tbi:
        type: File
        outputSource: GATK_SelectVariants/vcf_tbi
    fastqc1_html:
        type: File
        outputSource: FastQC_F/report_html
    fastqc1_zip:
        type: File
        outputSource: FastQC_F/report_zip
    fastqc2_html:
        type: File
        outputSource: FastQC_R/report_html
    fastqc2_zip:
        type: File
        outputSource: FastQC_R/report_zip
    



