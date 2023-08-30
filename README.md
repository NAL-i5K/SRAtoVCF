# SRAtoVCF
A pipeline for converting short-read DNA data from SRA into VCF files

## Prerequisite
* Pyhthon 3.6+
* edirect 12.5
* sra-tools 3.0.1
* Trimmomatic 0.39
* FastQC 0.12.1
* bwa-mem2 2.2.1
* samtools 1.17
* gatk 4.4.0.0
* cwltool 1.0+
### Using Docker container 
* Docker
### Using Singularity container 
* Singularity or SingularityCE or Apptainer
### On HPC
* conda

## The input parameter in the workflow (main.cwl)
The table shows the parameter settings for workflow.
| Input | Description |
| --- | --- |
| `ref_genome` | File path. Reference genome |
| `SRA_acession` | String. SRA accession for the data you want to process. |
| `input_adapters_file` | File path. The file contains the adapter sequence for Trimmomatic to trim. |
| `removeDuplicates` | Boolean. Whether to remove duplicates. |
| `ReadGroupID` | String. Read group identifier. ID must be unique. |
| `ReadGroupLibrary` | String. DNA preparation library identifier. |
| `ReadGroupPlatformUnit` | String. Platform Unit. |
| `ReadGroupPlatform` | String. Platform/technology used to produce the read. |
| `ReadGroupSampleName` | String. The name of the sample sequenced in this read group. |
| `CREATE_INDEX` | Boolean. Whether or not to create an index file for the BAM file after adding readgroup information. |
| `creat_variant_index` |  Boolean. Whether to create index file for HaplotypeCaller output. |
| `select_type_INDEL` | String. To select the INDEL form the HaplotypeCaller output vcf file.|
| `filter_expression_SNP` | String. The criteria for filtering SNPs. |
| `filter_expression_INDEL` | String. The criteria for filtering INDELs. |
| `exclude_filtered` | Boolean. Whether to remove duplicates. |
| `creat_index` | Boolean. Whether to create index file for the SortVcf vcf output. |

*The parameters to create an index file should not be changed, and it should keep with TRUE.

## Running on HPC (Cere)
### Step 1. Set up conda environment
First, we need to install the runner for the pipeline called cwltool to compile the pipeline. Therefore we have to set up a conda environment.

Load the latest version minconda module and creat an environment called cwltool.
```
module load miniconda
conda create --name cwltool
```
Next time just has to activate the environment. To activate the environment:
```
conda activate cwltool
```
Now we are inside the cwltool environment and can install the cwltool.
```
conda install -c conda-forge cwltool
conda install -c conda-forge cwl-utils #dependency
```

### Step 2. Download the singularity
Due to running on HPC, we need to use the singularity rather than the docker.

First, create a folder in your working directory to store the singularities that needed for the workflow and run the following code:
```
module load apptainer (singularityCE #or singularity (depend on the HPC))
cwl-docker-extract --singularity DIRECTORY ../workflow/main.cwl
export CWL_SINGULARITY_CACHE=your/sifDirectory/Path
```
If your computing node has internet, you can skip the cwl-docker-extract step and just load the apptainer (singularityCE) module.

**There are a few things to set up when using singularity.**

1. Set `CWL_SINGULARITY_CACHE`. to the folder containing all .sif files. This will make the cwl runtime automatically fetch the singularity container with this path.
2. Set `APPTAINER_CACHEDIR`. The default path is under the home directory, but the process will generate many files, resulting in insufficient storage space in the home directory. Therefore, this path needs to be in the project directory.
(Using singularityCE or singularity `APPTAINER_CACHEDIR` -> `SINGULARITY_CACHEDIR`)
   
### Step3. Run the workflow
**Download the organisum related SRA metadata on NCBI**
```
cwltool --singularity bioproject_meta_download.cwl --species_name Apis mellifera --output_file bee.tsv
```
**Prepared the reference genome index file**
```
cwltool --singularity [path to]/workflow/prep_ref.cwl --ref_genome PATH-to-ReferenceFile
```
**Processing the specific SRA file to vcf**
```
cwltool --singularity [path to]/SRAtoVCF/workflow/main.cwl ../SRAtoVCF/workflow/main.yml
```

## Running on local PC 
**Using Docker**
change the code to:
```
#original cwltool --singularity ....
cwltool --no-match-user ...
```
**Using local software (already have all the tools on local PC)**
change the code to:
```
#original cwltool --singularity ....
cwltool --no-container ...
```

## Build a shared conda environment and singularity image files
For multiple users to run the pipeline on HPC, it can create a shared conda environment for all the users. It can save some storage space.
### For conda environment
### Step 1. Create a conda environment in a shared directory.
```
conda create --prefix=SharedDirectoryPath/envname
```
### Step 2. Set up the environment variable and module in conda environment
Create the file for the environment setting.
```
cd SharedDirectoryPath/envname
mkdir -p ./etc/conda/activate.d
mkdir -p ./etc/conda/deactivate.d
touch ./etc/conda/activate.d/env_vars.sh
touch ./etc/conda/deactivate.d/env_vars.sh
```
Edit the environment setting when using the environment (./etc/conda/activate.d/env_vars.sh) as follow:
```
#!/bin/sh
module load apptainer
export CWL_SINGULARITY_CACHE=/project/nal_genomics/shared_files/SRAtoVCF/sif
```
If there are other settings you want to add, you can modify the content yourself.
Edit the environment setting  (./etc/conda/deactivate.d/env_vars.sh) as follow:
```
#!/bin/sh
module unload apptainer
unset CWL_SINGULARITY_CACHE
```
It will reset the setting when we leave the conda environment.
### Step 3. install cwltool
```
conda activate SharedDirectoryPath/envname
```
Now we are inside the cwltool environment and can install the cwltool.
```
conda install -c conda-forge cwltool
conda install -c conda-forge cwl-utils #dependency
```
You can check if the environment settings are right:
```
module list
#output
#Currently Loaded Modules:
  #1) miniconda/4.12.0   2) apptainer/1.2.2
echo $CWL_SINGULARITY_CACHE
#output
#/PathtoSharedSiFFolder
```
### Step 4. Leave conda environment
```
conda deactivate
```
### For shared singularity image files
### Step 1. Create a folder to store the singularity image files (sifs) in a shared directory and pull the sifs.
```
cd PathtoStoretheSingularityImageFiles
mkdir sif
cd sif
cwl-docker-extract --singularity . Pathto/workflow/main.cwl
```
### Step 1. Set the environment variable in conda env_var.sh file.
Just like the conda environment Step 2.

## Example
In the test example, we utilize the yeast data as an example. The example folder contains the reference sequence of R64, and the processed SRA accession is SRR23631020.

First, create the index file for the reference genome. (Remember to complete the setting first and run the command in the example directory.)
```
 cwltool --singularity ../workflow/prep_ref.cwl --ref_genome GCF_000146045.2_R64_genomic.fna

```
Second, generate the example YAML file for the main.cwl (main variant calling pipeline) by generate_example_yml.sh.
```
sh generate_example_yml.sh.
#it will print out Enter git clone path:
#if your git clone path is /path/to/git/clone you should just enter it.
```
Finally, run the main.cwl by following the command.
```
cwltool --singularity ../workflow/main.cwl example.yaml
```


