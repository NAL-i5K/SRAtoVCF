class: CommandLineTool
cwlVersion: v1.2

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: broadinstitute/gatk:latest

baseCommand:
  - gatk
inputs:
    input_bamfile:
        type: File
        inputBinding:
            position: 4
            prefix: '-I'
        doc: bam file produced after printReads
        secondaryFiles:
            - ^.bai
    output_filename:
        type: string
        inputBinding:
            position: 5
            prefix: '-O'
        doc: name of the output file from HaplotypeCaller
    reference:
        type: File
        inputBinding:
            position: 3
            prefix: '-R'
        secondaryFiles:
            - .fai
            - ^.dict
    ERC:
      type: string?
      inputBinding:
        prefix: -ERC
        position: 6
    creat_variant_index:
      type: boolean?
      inputBinding:
        prefix: --create-output-variant-index 
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

arguments:
  - position: 2
    valueFrom: HaplotypeCaller

   
