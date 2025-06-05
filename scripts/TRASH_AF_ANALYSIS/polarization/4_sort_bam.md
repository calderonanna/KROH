# Sorting BAM files
`samtools sort sample.sam -T sample_temp.bam -o sample_sorted.bam`
- `-T`: Write temporary files. 
- `-o`: Write the final sorted output to the specified file. 

## Create Scripts
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
for i in `cat $scripts/GWBW_IDS.txt`; do 
    cat <<EOT > $scripts/sort_bam_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2GB
#SBATCH --time=24:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic
#SBATCH --job-name=sort_bam_${i}
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run
samtools sort \$data/bam/${i}.bam -T \$data/bam/${i}_temp.bam -o \$data/bam/${i}_sorted.bam
EOT
done

#Submit each job
for i in `cat $scripts/GWBW_IDS.txt`; do
    sbatch $scripts/sort_bam_${i}.bash;
done
