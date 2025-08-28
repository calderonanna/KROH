# Genotype Polarization
To determine ancestral vs derived, I am using two closely related species (S. ruticilla and S. citrina) as well as two more distantly related species (V. cyanoptera and V. chrysoptera), which we have high quality squencing data for. 

# Adapter Removal
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#ID File 
cd $data/fastq
ls *G*R1* >> $scripts/GWBW_IDS.txt
ls *BW*R1* >> $scripts/GWBW_IDS.txt
sed -i 's/_R1_001.fastq.gz//g' $scripts/GWBW_IDS.txt


#FASTP
for i in $(cat $scripts/GWBW_IDS.txt); do
    cat <<EOT > $scripts/trim_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=trim_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

# Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

# Run fastp
fastp -i \$data/fastq/${i}_R1_001.fastq.gz \\
      -I \$data/fastq/${i}_R2_001.fastq.gz \\
      -o \$data/trim/${i}_R1_trimmed.fastq.gz \\
      -O \$data/trim/${i}_R2_trimmed.fastq.gz
EOT
done

#Submit Jobs
for i in `cat $scripts/GWBW_IDS.txt`; do 
    sbatch $scripts/trim_${i}.bash;
done
```

## Error Output
Just making sure jobs were not killed due to insufficient memory
```bash
ls -lhat trim*err* | grep "May" | awk '{print $9}' | xargs grep "OOM"
```