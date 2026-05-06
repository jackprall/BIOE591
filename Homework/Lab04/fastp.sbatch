#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=fastp                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=bioe-591-genomics/students/JackPrall/Lab4/outputs/fastp_demo-%j.out
#SBATCH --error=bioe-591-genomics/students/JackPrall/Lab4/errors/fastp_demo-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your fastp environment
conda activate fastp

# demo run fastp
fastp -i ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_mystacalis/Diglossa_mystacalis_163116_R1_001.fastq.gz \
-o ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/Diglossa_mystacalis_163116_R1_001_trimmed.fastq.gz \
-I ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_mystacalis/Diglossa_mystacalis_163116_R2_001.fastq.gz \
-O ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/Diglossa_mystacalis_163116_R2_001_trimmed.fastq.gz \
-h ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/sample.fastp.html \
-j ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/sample.fastp.json

# loop run fastp for all samples
for r1 in ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_mystacalis/*_R1_001.fastq.gz; do
    
    r2="${r1/_R1_001/_R2_001}"
    
    sample=$(basename "$r1" | sed 's/_R1_001.fastq.gz//')
    
    fastp \
      -i "$r1" \
      -I "$r2" \
      -o ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/${sample}_R1_001_trimmed.fastq.gz \
      -O ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/${sample}_R2_001_trimmed.fastq.gz \
      -h ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/${sample}.fastp.html \
      -j ~/bioe-591-genomics/students/JackPrall/Lab4/trimmed_reads/${sample}.fastp.json

done
