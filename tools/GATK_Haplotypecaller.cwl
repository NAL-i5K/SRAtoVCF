cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:latest

baseCommand: [gatk, HaplotypeCaller]
inputs:
    jave_option:
        type: string?
        inputBinding:
          position: 2
          prefix: '--java-options'
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
    ERC:
      type: string?
      inputBinding:
        prefix: -ERC
        position: 6
    creat_variant_index:
      default: true
      type: boolean?
      inputBinding:
        prefix: '--create-output-variant-index'
        position: 7
    bam_output:
      type: string
      inputBinding:
            position: 8
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


   
