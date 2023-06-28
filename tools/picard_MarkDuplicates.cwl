cwlVersion: v1.0
class: CommandLineTool

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 1024

hints:
  DockerRequirement:
      dockerPull: broadinstitute/gatk:latest
 
baseCommand: [gatk, MarkDuplicates]

inputs:
    input_files:
        type: File
        inputBinding:
            position: 3
            prefix: '-I'
    ValidationStringency:
        type: string?
        inputBinding:
            position: 4
            prefix: '--VALIDATION_STRINGENCY'    
    metricsFile:
        type: string?
        inputBinding:
            position: 5
            prefix: '-M'  
    output_filename:
        type: string
        inputBinding:
            position: 6
            prefix: '-O'    
    removeDuplicates:
        type: string?
        inputBinding:
            position: 7
            prefix: '--REMOVE_DUPLICATES'
       
outputs:
    markDups_output:
        type: File
        outputBinding:
            glob: $(inputs.output_filename)



