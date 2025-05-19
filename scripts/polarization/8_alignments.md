# Clustalo 

## Installation
```bash
bin="/storage/home/abc6435/SzpiechLab/bin"
cd $bin
```
## File Prep
```bash
nano $script/split_fa.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=8:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=split_fa
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/polar"
script="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

# #Rename Chromosomes
# while read id; do
#     sed -i -E "s/^(>chr[0-9]+)$/\1_${id}/" $work/${id}.fa
# done < "$work/SAM_IDS.txt"

#Split .fa by chr
while read id; do
    while read chr; do
        samtools faidx $work/${id}.fa
        samtools faidx $work/${id}.fa ${chr}_${id} > $work/${id}_${chr}.fa
    done < "$script/chrs.txt"
done < "$work/SAM_IDS.txt"
```