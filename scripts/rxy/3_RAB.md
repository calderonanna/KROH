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
maf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf"
rxy="/storage/group/zps5164/default/abc6435/KROH/data/rxy"
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous"

for mut in $muts; do
    echo $mut >> $rxy/results_4fold.txt
    python3 $scripts/RABmafs.py --fileA $maf/hKIWA_derived.maf --fileB $maf/cKIWA_derived.maf --fileN $rxy/4fold_synonymous.txt --fileM $rxy/${mut}.txt --seed 100 --psites 0.30 --iter 20 >> $rxy/results_4fold.txt
    echo '' >> $rxy/results_4fold.txt;
done