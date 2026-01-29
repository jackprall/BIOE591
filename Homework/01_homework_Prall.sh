#!/usr/bin/env bash

cd ~/week_1

mkdir -p fastq fasta metadata

mv *.fastq.gz fastq/
mv *.fasta fasta/
mv *.csv metadata/

ls -1 fastq/ | wc -l
ls -1 fasta/ | wc -l
ls -1 metadata/ | wc -l

echo "DONE!"
