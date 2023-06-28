class: CommandLineTool
cwlVersion: v1.0

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: $(inputs.nthreads)
hints:
  DockerRequirement:
    dockerPull: staphb/trimmomatic:latest
 
baseCommand: [trimmomatic]

inputs:
  end_mode:
    type: string
    default: 'PE'
    inputBinding:
      position: 2
  log_filename:
    type: string?
    inputBinding:
      position: 3
      prefix: '-trimlog'
  nthreads:
    default: 1
    type: int
    inputBinding:
      position: 4
      prefix: '-threads'
  phred:
    default: '64'
    type: string
    inputBinding:
      position: 5
      prefix: '-phred'
      separate: false
  R1_fastq_file:
    type: File
    inputBinding:
      position: 6
  R2_fastq_file:
    type: File?
    inputBinding:
      position: 7
  tophred33:
    type: boolean?
    inputBinding:
      position: 13
      prefix: TOPHRED33
      separate: false
  tophred64:
    type: boolean?
    inputBinding:
      position: 13
      prefix: TOPHRED64
      separate: false
  leading:
    type: int?
    inputBinding:
      position: 14
      prefix: 'LEADING:'
      separate: false
  slidingwindow:
    default: '4:15'
    type: string?
    inputBinding:
      position: 15
      prefix: 'SLIDINGWINDOW:'
      separate: false
  trailing:
    type: int?
    inputBinding:
      position: 16
      prefix: 'TRAILING:'
      separate: false
  illuminaclip:
    default: '2:30:10'
    type: string
  input_adapters_file:
    type: File
  minlen:
    type: int?
    inputBinding:
      position: 100
      prefix: 'MINLEN:'
      separate: false


  
outputs:
  log_file:
    type: File?
    outputBinding:
      glob: $(inputs.log_filename).log
  R1_trimmed_paired_file:
    type: File
    outputBinding:
      glob: |
        $(inputs.log_filename + '_1.trimmed.fastq')
  R1_trimmed_unpaired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE")
            return inputs.log_filename + '_1.U.trimmed.fastq';
          return null;
        }
  R2_trimmed_paired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE" && inputs.R2_fastq_file)
            return inputs.log_filename + '_2.trimmed.fastq';
          return null;
        }
  R2_trimmed_unpaired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE" && inputs.R2_fastq_file)
            return inputs.log_filename + '_2.U.trimmed.fastq';
          return null;
        }

arguments:
  - position: 8
    valueFrom: >-
      $(inputs.log_filename + '_1.trimmed.fastq')
  - position: 9
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.R2_fastq_file)
          return inputs.log_filename + '_1.trimmed.U.fastq';
        return null;
      }
  - position: 10
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.R2_fastq_file)
          return inputs.log_filename + '_2.trimmed.fastq';
        return null;
      }
  - position: 11
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.R2_fastq_file)
          return inputs.log_filename + '_2.trimmed.U.fastq';
        return null;
      }
  - position: 12
    valueFrom: >-
      $("ILLUMINACLIP:" + inputs.input_adapters_file.path + ":"+
      inputs.illuminaclip)

