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
#SBATCH --account=zps5164_sc
#SBATCH --job-name=extract_readlengths
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

for i in `cat $scripts_folder/cKIWA_IDS.txt`; do samtools view $data_folder/bam/${i}.bam | awk '{print length($10)}' >> $data_folder/seq_stats/${i}_readlength.txt; done 
```

## Download to Local Machine
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seq_stats/*.txt /Users/abc6435/Desktop/KROH/data/seq_stats
```

