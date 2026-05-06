#!/bin/bash

#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=pop_strucutre                  # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=2                       # number of nodes to allocate
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=16              # number of cores to allocate
#SBATCH --time=0-02:00:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab10/outputs/pop_strucutre-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab10/errors/pop_strucutre-%j.err

# set up the environment
module load Mamba/22.11.0-0;
eval "$(conda shell.bash hook)"
conda activate admixture

# run plink2
plink2 \
    --vcf /home/z41f731/bioe-591-genomics/course-materials/data/structure_data/sparrows.vcf \
    --allow-extra-chr \
    --make-bed \
    --out /home/z41f731/bioe-591-genomics/students/JackPrall/Lab10/results/sparrows

# lets make this easier for me
cd bioe-591-genomics/students/JackPrall/Lab10
    
# do this part    
awk 'BEGIN{OFS="\t"} {if(!($1 in a)) a[$1]=++i; $1=a[$1]; print}' results/sparrows.bim > results/sparrows.int.bim
cp results/sparrows.bed results/sparrows.int.bed
cp results/sparrows.fam results/sparrows.int.fam

# run admixture itself
admixture --cv results/sparrows.int.bed 2
admixture --cv results/sparrows.int.bed 3
admixture --cv results/sparrows.int.bed 4
