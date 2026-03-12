#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=vcftools                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=16              # number of cores to allocate
#SBATCH --time=0-02:00:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab7/outputs/bcf_demo-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab7/errors/bcf_demo-%j.err

## load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

## create your align environment
# mamba env create -f ~/bioe-591-genomics/students/JackPrall/vcftools.yml
conda activate vcftools 

## navigate to the lab 7 folder because I'm tired of the long file names
cd ~/bioe-591-genomics/students/JackPrall/Lab7/



## gzip the multi-vcf files for easier use and habit formation
# gzip MultiSample.vcf

## filter out the indels
# vcftools --gzvcf MultiSample.vcf.gz --remove-indels --recode --out NoIndels
    
## filter out low-quality sites (< 40 Phred-scaled quality score)
# vcftools --vcf NoIndels.recode.vcf --minQ 40 --recode --out NoLowQs

## last for now, filter out sites that are within 50 nucleuotides
# vcftools --vcf NoLowQs.recode.vcf --thin 50 --recode --out LongWay

## an example of doing this in one step, before the loop to make sure it works
# vcftools --gzvcf MultiSample.vcf.gz --remove-indels --minQ 40 --thin 50 \
#     --recode --out ShortWay

## run a loop to count SNPs for each round of filtering
# echo -e "file\tsnp_count" > snp_counts.tsv
# for f in *.vcf; do
#     count=$(bcftools view -H -v snps "$f" | wc -l)
#     echo -e "${f}\t${count}" >> snp_counts.tsv
# done

## run a summary of TsTv with vcftools
# vcftools --vcf LongWay.recode.vcf --TsTv-summary



## Now, do this from scratch with more filters
vcftools --gzvcf MultiSample.vcf.gz --remove-indels --minQ 40 --thin 50 \
    --mac 3 --maf 0.167 --max-missing-count 2 --recode --out HomeworkExample

## Finally, gather the pi values for this multi-vcf
vcftools --vcf HomeworkExample.recode.vcf --site-pi --out HomeworkExample
