## Create Scripts
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
for i in `cat $scripts/GWBW_IDS.txt`; do 
    cat <<EOT > $scripts/sam_bam_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=sam_bam_${i}
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run samtools
samtools view -S -b \$data/sam/${i}.sam > \$data/bam/${i}.bam
EOT
done

#Submit each script and check job
for i in `cat $scripts/GWBW_IDS.txt`; do 
    sbatch $scripts/sam_bam_${i}.bash;
done