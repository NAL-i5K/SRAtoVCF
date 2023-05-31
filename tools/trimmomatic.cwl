class: CommandLineTool
cwlVersion: v1.2

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: staphb/trimmomatic:latest
 
baseCommand:
  - trimmomatic
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
  input_read1_fastq_file:
    type: File
    inputBinding:
      position: 6
  input_read2_fastq_file:
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
  output_log_file:
    doc: Trimmomatic Log file.
    type: File?
    outputBinding:
      glob: $(inputs.log_filename)
  output_read1_trimmed_paired_file:
    type: File
    outputBinding:
      glob: >-
        $(inputs.input_read1_fastq_file.path.replace(/^.*[\\\/]/,
        '').replace(/\.[^/.]+$/, '') + '.trimmed.fastq')
  output_read1_trimmed_unpaired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE")
            return inputs.input_read1_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.unpaired.trimmed.fastq';
          return null;
        }
  output_read2_trimmed_paired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE" && inputs.input_read2_fastq_file)
            return inputs.input_read2_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.trimmed.fastq';
          return null;
        }
  output_read2_trimmed_unpaired_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.end_mode == "PE" && inputs.input_read2_fastq_file)
            return inputs.input_read2_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.unpaired.trimmed.fastq';
          return null;
        }

arguments:
  - position: 8
    valueFrom: >-
      $(inputs.input_read1_fastq_file.path.replace(/^.*[\\\/]/,
      '').replace(/\.[^/.]+$/, '') + '.trimmed.fastq')
  - position: 9
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.input_read2_fastq_file)
          return inputs.input_read1_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.trimmed.unpaired.fastq';
        return null;
      }
  - position: 10
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.input_read2_fastq_file)
          return inputs.input_read2_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.trimmed.fastq';
        return null;
      }
  - position: 11
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.input_read2_fastq_file)
          return inputs.input_read2_fastq_file.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '') + '.trimmed.unpaired.fastq';
        return null;
      }
  - position: 12
    valueFrom: >-
      $("ILLUMINACLIP:" + inputs.input_adapters_file.path + ":"+
      inputs.illuminaclip)

