
# Sorting BAM files
When you align FASTQ files with all current sequence aligners, the alignments produced are in random order with respect to their position in the reference genome. In other words, the BAM file is in the order that the sequences occurred in the input FASTQ files. It must be sorted such that the alignments occur in “genome order”. That is, ordered positionally based upon their alignment coordinates on each chromosome.

## Create Scripts
`samtools sort sample.sam -T sample_temp.bam -o sample_sorted.bam`
- `-T`: Write temporary files. 
- `-o`: Write the final sorted output to the specified file. 

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run Loop
for i in `cat $scripts_folder/cKIWA_IDS.txt`; do
    cat <<EOT > $scripts_folder/sort_bam_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2GB
#SBATCH --time=24:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=sort_bam_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run Samtools Sort
samtools sort \$data_folder/bam/${i}.bam -T \$data_folder/bam/${i}_temp.bam -o \$data_folder/bam/${i}_sorted.bam
EOT
done

#Submit each job
for i in $scripts_folder/sort_bam_*.bash; do
    sbatch ${i}
done

#Check Job Status
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```