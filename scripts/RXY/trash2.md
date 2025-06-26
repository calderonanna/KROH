# Subset MAF Files

```bash
nano $scripts/subset_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=subset_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
work='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Reformat mafs
zcat $work/cKIWA.mafs.gz | awk '{print $1, $2-1, $2, $0}' OFS="\t" | sed 1d >> $work/cKIWA.mafs.gz.bed
zcat $work/hKIWA.mafs.gz | awk '{print $1, $2-1, $2, $0}' OFS="\t" | sed 1d >> $work/hKIWA.mafs.gz.bed

#Intersect
bedtools intersect -a $work/cKIWA.mafs.gz.bed -b $work/chKIWA_intersected.bed > $work/intersected_cKIWA.mafs.gz.bed