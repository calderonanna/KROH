# Aligning Contemporary Samples with BWA
https://bio-bwa.sourceforge.net/bwa.shtml

## Installation
See [contemporary/2_bwa_alignments](../contemporary/2_bwa_alignments.md)

## Index the Reference
See [contemporary/2_bwa_alignments](../contemporary/2_bwa_alignments.md)

## Aligning the historical samples
`bwa aln -n 0.01 -l 1024 -o 2 <reference_genome.fasta> trimmed_reads_1.fastq trimmed_reads_2.fastq > output.sai`

- `bwa aln`: Aligns paired-end reads to a reference genome
- `-n`: error rate.
- `-l`: seeding length
- `-o`: Gap exension penalty

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Make a directory for sam files
if [ ! -d "$data_folder/sai" ]; then
    mkdir -p "$data_folder/sai"
fi

#Create a script for each contemporary file
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/bwa_alignments_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_alignments_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Run BWA (with resource profiling)
/usr/bin/time -v bwa aln -n 0.01 -l 1024 -o 2 -t 4 \\
\$mywa_folder/mywagenomev2.1 \\
\$data_folder/trim/${i}_R1_trimmed.fastq.gz \\
\$data_folder/trim/${i}_R2_trimmed.fastq.gz > \$data_folder/sai/${i}.sai 2> \$err_folder/${i}_bwa.err
EOT
done

#Submit Each Script
for i in $scripts_folder/bwa_alignments*; do
    sbatch ${i}
done

#Check Job
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```

## Checking Alignment Stats
```bash
#Set Variable
sam_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sam"
for i in $sam_folder/*.sam; do
    echo "$(basename ${i})" >> $sam_folder/alignment_stats.txt
    echo "----------------------" >> $sam_folder/alignment_stats.txt
    samtools flagstat ${i} >> $sam_folder/alignment_stats.txt
    echo " " >> $sam_folder/alignment_stats.txt
done
```