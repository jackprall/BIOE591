#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=align                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=16              # number of cores to allocate
#SBATCH --time=0-06:00:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab5/outputs/bwa_demo-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab5/errors/bwa_demo-%j.err

## load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

## create your align environment
## mamba env create -f bioe-591-genomics/students/JackPrall/align.yaml
conda activate align 

## Copy the fasta into my folder
## cp bioe-591-genomics/course-materials/data/references/hemoglobin_references.fasta bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta

## Index the fasta with bwa
## bwa index bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta

## Index the fasta with samtools
## samtools faidx bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta

## Align the reads with 'bwa mem'
## bwa mem -t 4 bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/Diglossa_mystacalis_163116_R1_001_trimmed.fastq.gz bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/Diglossa_mystacalis_163116_R2_001_trimmed.fastq.gz > bioe-591-genomics/students/JackPrall/Lab5/sams/Diglossa_mystacalis_163116.sam

## Visualize the alignment with samtools
## samtools view -b bioe-591-genomics/students/JackPrall/Lab5/sams/Diglossa_mystacalis_163116.sam | samtools sort -o bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam
## samtools index bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam

## Examine the mapping statistics with samtools
## samtools flagstat bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam > bioe-591-genomics/students/JackPrall/Lab5/alignment_stats/Diglossa_mystacalis_163116.alignment_stats.txt
## samtools depth bioe-591-genomics/students/JackPrall/Lab5/bams/Diglossa_mystacalis_163116.sorted.bam | awk '{sum+=$3} END {print sum/NR}' > bioe-591-genomics/students/JackPrall/Lab5/alignment_stats/Diglossa_mystacalis_163116.depth.txt

## Loop through all of the samples, using each of the methods we used above
for r1 in ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/*_R1_001_trimmed.fastq.gz; do
    
    ## Call the correct files
    r2="${r1/_R1_001_trimmed.fastq.gz/_R2_001_trimmed.fastq.gz}"

    ## Extract sample name
    sample=$(basename "${r1%_R1_001_trimmed.fastq.gz}")
    
    ## Align the reads with 'bwa mem'    
    bwa mem -t 4 \
        ~/bioe-591-genomics/students/JackPrall/Lab5/hemoglobin_references.fasta \
        "$r1" "$r2" \
        > ~/bioe-591-genomics/students/JackPrall/Lab5/sams/${sample}.sam    

    ## Convert the sam files into sorted bam files with samtools
    samtools view -b \
        ~/bioe-591-genomics/students/JackPrall/Lab5/sams/${sample}.sam \
        | samtools sort -o \
        ~/bioe-591-genomics/students/JackPrall/Lab5/bams/${sample}.sorted.bam    
    
    ## Index these bam files, creating .bai files
    samtools index ~/bioe-591-genomics/students/JackPrall/Lab5/bams/${sample}.sorted.bam

    ## Examine the mapping statistics with samtools
    samtools flagstat \
        ~/bioe-591-genomics/students/JackPrall/Lab5/bams/${sample}.sorted.bam \
        > ~/bioe-591-genomics/students/JackPrall/Lab5/alignment_stats/${sample}.alignment_stats.txt
     
    ## Gather the read depth    
    samtools depth \
        ~/bioe-591-genomics/students/JackPrall/Lab5/bams/${sample}.sorted.bam \
        | awk '{sum+=$3} END {print sum/NR}' \
        > ~/bioe-591-genomics/students/JackPrall/Lab5/alignment_stats/${sample}.depth.txt

done
