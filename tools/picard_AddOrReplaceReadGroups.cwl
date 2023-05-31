class: CommandLineTool
cwlVersion: v1.2

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
      dockerPull: broadinstitute/gatk:latest

baseCommand:
  - gatk
  - AddOrReplaceReadGroups
inputs:
  input:
    type: File
    inputBinding:
      position: 3
      prefix: INPUT=
      separate: false
  output:
    type: string
    inputBinding:
      position: 4
      prefix: OUTPUT=
      separate: false
  SortOrder:
    type: string?
    inputBinding:
      position: 6
      prefix: SORT_ORDER=
      separate: false
  ReadGroupID:
    type: string
    inputBinding:
      position: 7
      prefix: RGID=
      separate: false
  ReadGroupLibrary:
    type: string
    inputBinding:
      position: 8
      prefix: RGLB=
      separate: false
  ReadGroupPlatform:
    type: string
    inputBinding:
      position: 9
      prefix: RGPL=
      separate: false
  ReadGroupPlatformUnit:
    type: string
    inputBinding:
      position: 10
      prefix: RGPU=
      separate: false
  ReadGroupSampleName:
    type: string
    inputBinding:
      position: 11
      prefix: RGSM=
      separate: false
  ReadGroupSequenceCenter:
    type: string?
    inputBinding:
      position: 12
      prefix: RGCN=
      separate: false
  ReadGroupDescription:
    type: string?
    inputBinding:
      position: 13
      prefix: RGDS=
      separate: false
  ReadGroupRunDate:
    type: string?
    inputBinding:
      position: 14
      prefix: RGDT=
      separate: false
  ReadGroupPredictedInsertSize:
    type: string?
    inputBinding:
      position: 15
      prefix: RGPI=
      separate: false
  ReadGroupProgramGroup:
    type: string?
    inputBinding:
      position: 16
      prefix: RGPG=
      separate: false
  ReadGroupPlatformModel:
    type: string?
    inputBinding:
      position: 17
      prefix: RGPM=
      separate: false
  CREATE_INDEX:
    type: string
    inputBinding:
      position: 5
      prefix: CREATE_INDEX=
      separate: false
outputs:
  out_bam:
    type: File?
    secondaryFiles:
      - ^.bai
    outputBinding:
      glob: $(inputs.output)



