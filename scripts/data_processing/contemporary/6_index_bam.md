# Index Marked BAM files

## Create Scripts
`samtools index sample.bam sample.bai`
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

for i in `cat $scripts_folder/cKIWA_IDS.txt`; do
    cat<<EOT > $scripts_folder/index_bam_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20MB
#SBATCH --time=00:30:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=index_bam_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Index BAM Files
samtools index \$data_folder/bam/${i}_marked.bam \$data_folder/bam/${i}_marked.bai
EOT
done

#Submit each script
for i in $scripts_folder/index_bam*.bash; do
    sbatch ${i}
done

#Check Job Status
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435

```