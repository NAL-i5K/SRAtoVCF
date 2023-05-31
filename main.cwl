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
    SRA_accession:
        type: string 
    phred:
        type: string
    tophred33:
        type: boolean
    tophred64:
        type: boolean
    slidingwindow:
        type: string
    trailing:
        type: int
    illuminaclip:
        type: string
    input_adapters_file:
        type: File
    minlen:
        type: int
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
    filter_expression:
        type: string


steps:
    prep_refgenom:
        run: tools/prep_ref.cwl
        in: 
            ref_genome: ref_genome
        out: [index_ref]
    get_sra_file:
        run: tools/prefetch.cwl
        in: 
            accession: SRA_accession
        out: [sra_file]
    download_sra_file:
        run: tools/fastq-dump.cwl
        in: 
            SRA_file: 
                source: get_sra_file/sra_file
        out: [forward, reverse]
    FastQC_F:
        run: tools/fastqc.cwl
        in:
            input_file: 
                source: download_sra_file/forward
        out: [report_html, report_zip]
    FastQC_R:
        run: tools/fastqc.cwl
        in:
            input_file: 
                source: download_sra_file/reverse
        out: [report_html, report_zip]
    Trimmomatic:
        run: tools/trimmomatic.cwl
        in:
            phred: phred
            input_read1_fastq_file: 
                source: download_sra_file/forward
            input_read2_fastq_file: 
                source: download_sra_file/reverse
            tophred33: tophred33
            tophred64: tophred64
            slidingwindow: slidingwindow
            trailing: trailing
            illuminaclip: illuminaclip
            input_adapters_file: input_adapters_file
            minlen: minlen
        out: [output_log_file,output_read1_trimmed_paired_file,output_read1_trimmed_unpaired_file,output_read2_trimmed_paired_file,output_read2_trimmed_unpaired_file]
    BWA_mem:
        run: tools/bwa_mem.cwl
        in:
            reference: 
                source: prep_refgenom/index_ref
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + ".sam"}
            read_F:
                source: Trimmomatic/output_read1_trimmed_paired_file
            read_R:
                source: Trimmomatic/output_read2_trimmed_paired_file
        out: [output]
    Sort_sam:
        run: tools/samtools_sort.cwl
        in:
            input: 
                source: BWA_mem/output
            output_name: 
                source: SRA_accession
                valueFrom: ${ return self + ".bam"}
        out: [sorted]
    Picard_MarkDuplicates:
        run: tools/picard_MarkDuplicates.cwl
        in:
            input_files: 
                source: Sort_sam/sorted
            metricsFile:
                source: SRA_accession
                valueFrom: ${ return self + "_metrics.txt"}
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + "markdup.bam"}
            removeDuplicates: removeDuplicates 
        out: [markDups_output]
    Picard_AddOrReplacereadGroup:
        run: tools/picard_AddOrReplaceReadGroups.cwl
        in:
            input: 
                source: Picard_MarkDuplicates/markDups_output
            output: 
                source: SRA_accession
                valueFrom: ${ return self + "markdup_RG.bam"}
            ReadGroupID: ReadGroupID
            ReadGroupLibrary: ReadGroupLibrary
            ReadGroupPlatform: ReadGroupPlatform
            ReadGroupPlatformUnit: ReadGroupPlatformUnit
            ReadGroupSampleName: ReadGroupSampleName
            CREATE_INDEX: CREATE_INDEX
        out: [out_bam]
    GATK_HaplotypeCaller:
        run: tools/GATK_Haplotypecaller.cwl
        in:
            input_bamfile:  
                source: Picard_AddOrReplacereadGroup/out_bam
            output_filename: 
                source: SRA_accession
                valueFrom: ${ return self + ".vcf.gz"}
            reference: 
                source: prep_refgenom/index_ref
            bam_output: 
                source: SRA_accession
                valueFrom: ${ return self + "_haplotype.bam"}
            creat_variant_index: creat_variant_index
        out: [output_file,output_file_bam]
    GATK_VariantFiltration:
        run: tools/GATK_VariantFiltration.cwl
        in:
            vcf_file: 
                source: GATK_HaplotypeCaller/output_file
            reference: 
                source: prep_refgenom/index_ref
            output:
                source: SRA_accession
                valueFrom: ${ return self + "_filter.vcf.gz"}
            filter_expression: filter_expression
        out: [vcf]
outputs:
    vcf:
        type: File
        outputSource: GATK_VariantFiltration/vcf
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
    SRA_F:
        type: File
        outputSource: download_sra_file/forward
    SRA_R:
        type: File
        outputSource: download_sra_file/reverse
 



