# Obtain Read Lengths 
Extract read lengths with SAMTOOLS and then plot the distribution in R. 

## Create Script
```bash
#Set Variables and make a folder
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

if [ ! -d "$data_folder/seq_stats" ]; then
    mkdir -p "$data_folder/seq_stats"
fi

nano $scripts_folder/extract_readlenghts.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=5:00:00
#SBATCH --mem=5GB
#SBATCH --account=open
#SBATCH --job-name=extract_readlengths
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

# for i in `cat $scripts_folder/cKIWA_IDS.txt`; do 
#     samtools view $data_folder/bam/${i}_marked.bam \
#     | awk '{print length($10)}' \
#     >> $data_folder/seq_stats/${i}_readlength.txt;
# done 

for i in `cat $scripts_folder/hKIWA_IDS.txt`; do 
    samtools view $data_folder/bam/${i}_marked.bam \
    | awk '{print length($10)}' \
    >> $data_folder/seq_stats/${i}_readlength.txt;
done 


samtools view $data_folder/bam/759877_marked.bam | awk '{print length($10)}' >> $data_folder/seq_stats/759877_readlength.txt
```

