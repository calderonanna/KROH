# BWA- aln Alignments
https://bio-bwa.sourceforge.net/bwa.shtml

For aDNA or hDNA is prone to "reference bias", biases against alleles not found in the reference. In other words, reads carrying alleles not found in the reference are less likely to be mapped, so this will result in less alternate alleles and this is more problematic for aDNA because of contamination and postmortem damage.
Parameters for bwa aln were set based on recommendations for aDNA short reads from Oliva et al. 2021 (https://doi.org/10.1093/bib/bbab076, and DOI: 10.1002/ece3.8297). 

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

#Create scripts for R1
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/bwa_aln_R1_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10GB
#SBATCH --time=300:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_aln_R1_${i}

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#bwaaln R1
/usr/bin/time -v bwa aln -t 16 -n 0.01 -l 1024 -o 2 \\
\$mywa_folder/mywagenomev2.1 \\
\$data_folder/trim/${i}_R1_trimmed.fastq.gz > $data_folder/sai/${i}_R1.sai \\
2> \$err_folder/${i}_R1_bwaaln.err
EOT
done

#Submit Each Script
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do
    sbatch $scripts_folder/bwa_aln_R1_${i}.bash
done

#Create scripts for R2
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/bwa_aln_R2_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10GB
#SBATCH --time=300:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_aln_R2_${i}

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#bwaaln R2
/usr/bin/time -v bwa aln -t 16 -n 0.01 -l 1024 -o 2 \\
\$mywa_folder/mywagenomev2.1 \\
\$data_folder/trim/${i}_R2_trimmed.fastq.gz > $data_folder/sai/${i}_R2.sai \\
2> \$err_folder/${i}_R2_bwaaln.err
EOT
done

#Submit Each Script
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do
    sbatch $scripts_folder/bwa_aln_R2_${i}.bash
done

#Check Job
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
squeue --account=zps5164_sc
```