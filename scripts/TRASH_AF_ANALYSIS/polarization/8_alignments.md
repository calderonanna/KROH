# MAFFT 

## Installation
```bash
cd /storage/home/abc6435/SzpiechLab/bin/mafft-7.490-without-extensions/core
wget https://mafft.cbrc.jp/alignment/software/mafft-7.490-without-extensions-src.tgz
gunzip -cd mafft-7.490-without-extensions-src.tgz | tar xfv -

cd mafft-7.490-without-extensions/core

# Specify path
nano Makefile
PREFIX = /storage/home/abc6435/SzpiechLab/bin/mafft

#install
make
make install

#mafft should now be installed in the specified path
cd /storage/home/abc6435/SzpiechLab/bin/mafft

#test installation succsessful
./mafft --help

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

#Rename Chromosomes
while read id; do
    sed -i -E "s/^(>chr[0-9]+)$/\1_${id}/" $work/${id}.fa
done < "$work/SAM_IDS.txt"

#Split .fa by chr
while read id; do
    while read chr; do
        samtools faidx $work/${id}.fa
        samtools faidx $work/${id}.fa ${chr}_${id} > $work/${id}_${chr}.fa
    done < "$script/chrs.txt"
done < "$work/SAM_IDS.txt"

#Concatenate chr.fa
while read chr; do
    cat $work/*${chr}.fa > $work/${chr}_combined.fa;
done < "$script/chrs.txt"
```

## Run mafft
```bash
nano $script/mafft_align.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=8:00:00
#SBATCH --account=open
#SBATCH --job-name=mafft_align
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
mafft_tool="/storage/home/abc6435/SzpiechLab/bin/mafft/mafft"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/polar"
script="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#run mafft with resource monitoring
/usr/bin/time $mafft_tool --auto $work/chr1_combined.fa > $work/chr1_combined_mafft.fa
```