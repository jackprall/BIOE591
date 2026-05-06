#!/bin/bash

#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=ngs_test                  # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --mem=5G
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-02:00:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab9/outputs/ngs-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab9/errors/ngs-%j.err

module load Mamba/23.11.0-0;
eval "$(conda shell.bash hook)"
conda activate ngsrelate

cd bioe-591-genomics/students/JackPrall/Lab9

# gzip the vcf
bcftools view -Oz -o data/Addax10.vcf.gz data/Addax_MaxMissing10.recode.vcf

# index the vcf
tabix -p vcf data/Addax10.vcf.gz

# generate a sample ID file
bcftools query -l data/Addax10.vcf.gz > results/Addax10_ids.txt

# call ngsRelate
ngsRelate -h data/Addax10.vcf.gz -T GT -c 1 -O results/Addax10.ngsrelate.out -z results/Addax10_ids.txt

# repeat with the other sample (wasn't sure if I was supposed to)
bcftools view -Oz -o data/Addax40.vcf.gz data/Addax_MaxMissing40.recode.vcf
tabix -p vcf data/Addax40.vcf.gz
bcftools query -l data/Addax40.vcf.gz > results/Addax40_ids.txt
ngsRelate -h data/Addax40.vcf.gz -T GT -c 1 -O results/Addax40.ngsrelate.out -z results/Addax40_ids.txt