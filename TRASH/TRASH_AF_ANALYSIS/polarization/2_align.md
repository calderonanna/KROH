# Alig with BWA

## Create Scripts
`bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 2 \
reference. \
${i}_pair1.truncated.gz \
${i}_.pair2.truncated.gz > ${i}.sam 2> logs/${i}_bwa.err`

```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

for i in `cat $scripts/GWBW_IDS.txt`; do 
    cat <<EOT > $scripts/bwa_alignments_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=standard
#SBATCH --job-name=bwa_alignments_${i}
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"

#Run BWA
bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 4 \\
    \$mywa/mywagenomev2.1 \\
    \$data/trim/${i}_R1_trimmed.fastq.gz \\
    \$data/trim/${i}_R2_trimmed.fastq.gz > \$data/sam/${i}.sam 2> \$err/${i}_bwa.err
EOT
done

#Submit Each Script
for i in `cat $scripts/GWBW_IDS.txt`; do 
    sbatch $scripts/bwa_alignments_${i}.bash;
done

#Check Job
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```

## Alignment Stats
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