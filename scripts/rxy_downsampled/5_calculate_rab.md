# Calculate RAB

## Install Python Packages
```bash
#install python packages
python3 -m venv ~/RABmafs_env
source ~/RABmafs_env/bin/activate
pip install --upgrade pip
pip install pandas numpy argparse
```

## Run RABmafs.py
```bash
nano $scripts/RAB.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=10:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=RAB
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#activate env
source ~/RABmafs_env/bin/activate

#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
workdir="/storage/group/zps5164/default/abc6435/KROH/data/rxy"
muts="deleterious lossoffunction nonsynonymous tolerated intergenic noncoding synonymous"

#Run RABmafs.py
for mut in $muts; do
    echo $mut >> $workdir/results/rab_results.txt
    python3 $scripts/RABmafs.py --popA_derived $workdir/derived/hKIWA_derived.maf --popB_derived $workdir/derived/cKIWA_derived.maf --intergenic_sites $workdir/muts/intergenic.txt --mutation_sites $workdir/muts/$mut.txt --seed 46 --Psites 0.90 --iter 20 >> $workdir/results/rab_results.txt;
done


# python3 $scripts/RABmafs.py --popA_derived $workdir/derived/cKIWA_derived.maf --popB_derived $workdir/derived/cKIWA_derived.maf --intergenic_sites $workdir/muts/intergenic.txt --mutation_sites $workdir/muts/intergenic.txt --seed 100 --Psites 0.70 --iter 20 