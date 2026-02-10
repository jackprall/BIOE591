#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=BIOE591Lab3                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:10:00                 # Maximum job run time
#SBATCH --output=BIOE591Lab3-%j.out
#SBATCH --error=BIOE591Lab3-%j.err

## Run 'man sbatch' for more information on the options above.

module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"
conda activate demo_new
seqtk sample -s100 catamenia_analis.fastq.gz 1000 > SubsampleList.txt
