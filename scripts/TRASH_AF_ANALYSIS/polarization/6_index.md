# Index Marked BAM files

## Create Scripts
`samtools index sample.bam sample.bai`
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
for i in `cat $scripts/GWBW_IDS.txt`; do 
    cat <<EOT > $scripts/index_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=index_${i}
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Index BAM Files
samtools index \$data_folder/bam/${i}_marked.bam \$data_folder/bam/${i}_marked.bai
EOT
done

#Submit each job
for i in `cat $scripts/GWBW_IDS.txt`; do 
    sbatch $scripts/index_${i}.bash;
done
```