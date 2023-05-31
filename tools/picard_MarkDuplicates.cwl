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
    input_files:
        type: [string, File]
        inputBinding:
            position: 3
            prefix: INPUT=
        
    metricsFile:
        type: string?
        inputBinding:
            position: 5
            prefix: METRICS_FILE=
        
    output_filename:
        type: string
        inputBinding:
            position: 6
            prefix: OUTPUT=
        
    removeDuplicates:
        type: string?
        inputBinding:
            position: 7
            prefix: REMOVE_DUPLICATES=
       
outputs:
    markDups_output:
        type: File
        outputBinding:
            glob: $(inputs.output_filename)

arguments:
  - position: 4
    valueFrom: VALIDATION_STRINGENCY=SILENT
  - position: 2
    prefix: ''
    shellQuote: false
    valueFrom: MarkDuplicates
