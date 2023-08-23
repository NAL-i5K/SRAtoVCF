class: CommandLineTool
cwlVersion: v1.0

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
      dockerPull: broadinstitute/gatk:4.4.0.0

baseCommand: [gatk, AddOrReplaceReadGroups]

inputs:
  input:
    type: File
    inputBinding:
      position: 3
      prefix: '-I'

  output:
    type: string
    inputBinding:
      position: 4
      prefix: '-O'

  CREATE_INDEX:
    default: 'true'
    type: string?
    inputBinding:
      position: 5
      prefix: '--CREATE_INDEX'

  SortOrder:
    type: string?
    inputBinding:
      position: 6
      prefix: '--SORT_ORDER'

  ReadGroupID:
    type: string
    inputBinding:
      position: 7
      prefix: '--RGID'

  ReadGroupLibrary:
    type: string
    inputBinding:
      position: 8
      prefix: '--RGLB'

  ReadGroupPlatform:
    type: string
    inputBinding:
      position: 9
      prefix: '--RGPL'

  ReadGroupPlatformUnit:
    type: string?
    inputBinding:
      position: 10
      prefix: '--RGPU'

  ReadGroupSampleName:
    type: string
    inputBinding:
      position: 11
      prefix: '--RGSM'

  ReadGroupSequenceCenter:
    type: string?
    inputBinding:
      position: 12
      prefix: '--RGCN'

  ReadGroupDescription:
    type: string?
    inputBinding:
      position: 13
      prefix: '--RGDS'

  ReadGroupRunDate:
    type: string?
    inputBinding:
      position: 14
      prefix: '--RGDT'

  ReadGroupPredictedInsertSize:
    type: string?
    inputBinding:
      position: 15
      prefix: '--RGPI'

  ReadGroupProgramGroup:
    type: string?
    inputBinding:
      position: 16
      prefix: "--RGPG"

  ReadGroupPlatformModel:
    type: string?
    inputBinding:
      position: 17
      prefix: '--RGPM'


outputs:
  out_bam:
    type: File?
    secondaryFiles:
      - ^.bai
    outputBinding:
      glob: $(inputs.output)



