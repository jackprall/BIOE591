#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=bcftools                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=16              # number of cores to allocate
#SBATCH --time=0-06:00:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab6/outputs/bcf_demo-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab6/errors/bcf_demo-%j.err

## load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

## create your align environment
# mamba env create -f ~/bioe-591-genomics/students/JackPrall/bcftools.yaml
conda activate bcftools 

## Start using bcftools with the mpileup command
# bcftools mpileup -f \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam \
#     | head -n 50 \
#     > ~/bioe-591-genomics/students/JackPrall/Lab6/mpileup_output.txt

## Instead of just looking at this, pipe it into the call 'function'    
# bcftools mpileup -f \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam \
#     | bcftools call -mv -Ov -o \
#     ~/bioe-591-genomics/students/JackPrall/Lab6/Diglossa_mystacalis_163116.vcf
    
## Pull the high-level stats
# bcftools stats \
#     ~/bioe-591-genomics/students/JackPrall/Lab6/Diglossa_mystacalis_163116.vcf \
#     | grep ^SN

## Count the number of variants
# bcftools view -H \
#     ~/bioe-591-genomics/students/JackPrall/Lab6/Diglossa_mystacalis_163116.vcf \
#     | wc -l

## Count the number of SNPs
# bcftools view -H -v snps \
#     ~/bioe-591-genomics/students/JackPrall/Lab6/Diglossa_mystacalis_163116.vcf \
#     | wc -l

## Repeat the "function" step, but store all data in a multi-vcf
# bcftools mpileup -f \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta \
#     ~/bioe-591-genomics/students/JackPrall/Lab5/bams/*.sorted.bam \
#     | bcftools call -mv -Ov -o \
#     ~/bioe-591-genomics/students/JackPrall/Lab6/MultiSample.vcf

## Create a summary file from this multi-vcf
bcftools stats \
    ~/bioe-591-genomics/students/JackPrall/Lab6/MultiSample.vcf \
    | grep ^SN \
    > ~/bioe-591-genomics/students/JackPrall/Lab6/MultiSample_Summary.txt