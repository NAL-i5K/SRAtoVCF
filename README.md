# SRAtoVCF
A pipeline for converting short-read DNA data from SRA into VCF files

## Running on HPC
### Step 1. Set up conda environment
First, we need to install the runner for the pipeline called cwltool to compile the pipeline. Therefore we have to set up a conda environment.

Load the latest version minconda module and creat an environment called cwltool.
```
module load miniconda
conda create --name cwltool
```
Next time just has to activate the environment. To activate the environment:
```
 source activate cwltool
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
module load singularityCE #or singularity (depend on the HPC)
cwl-docker-extract --singularity DIRECTORY ../workflow/main.cwl
export CWL_SINGULARITY_CACHE=your/sifDirectory/Path
```
If your computing node has internet, you can skip the cwl-docker-extract step and just load the singularityCE module.

### Step3. Run the workflow
**Download the organisum related SRA metadata on NCBI**
```
cwltool --singularity bioproject_meta_download.cwl --species_name Apis mellifera --output_file bee.tsv
```
**Prepared the reference genome index file**
```
cwltool --singularity ../workflow/prep_ref.cwl --ref_genome PATH-to-ReferenceFile
```
**Processing the specific SRA file to vcf**
```
cwltool --singularity ../SRAtoVCF/workflow/main.cwl ../SRAtoVCF/workflow/main.yml
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


