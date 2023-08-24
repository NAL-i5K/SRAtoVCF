cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: $(inputs.threads)
    ramMin: 8000
    ramMax: 16000

hints:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.4.0.0

baseCommand: [gatk, HaplotypeCaller]

inputs:
    reference:
        type: File
        inputBinding:
            position: 3
            prefix: '-R'
        secondaryFiles:
            - .fai
            - ^.dict
    input_bamfile:
        type: File
        inputBinding:
            position: 4
            prefix: '-I'
        secondaryFiles:
            - ^.bai
    output_filename:
        type: string
        inputBinding:
            position: 5
            prefix: '-O'
    threads:
      default: 2
      type: int
      inputBinding:
        position: 6
        prefix: '--native-pair-hmm-threads'
    ERC:
      type: string?
      inputBinding:
        prefix: '-ERC'
        position: 7
    creat_variant_index:
      default: "TRUE"
      type: boolean?
      inputBinding:
        prefix: '--create-output-variant-index'
        position: 8
    bam_output:
      type: string
      inputBinding:
            position: 9
            prefix: '-bam-output'
    
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    secondaryFiles:
      - .tbi
  output_file_bam:
    type: File
    outputBinding:
      glob: $(inputs.bam_output)


   
