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

#run RABmafs
for mut in $muts; do
    python3 $scripts/RABmafs.py --fileA $maf/hKIWA_derived.maf --fileB $maf/cKIWA_derived.maf --fileN $rxy/4fold_synonymous.txt --fileM $rxy/${mut}.txt --seed 100 --psites 0.30 --iter 20 >>
done

#modify data
for mut in $muts; do
    grep ^$mut results_4fold.txt > mut;
done

grep ^"RAB =" results_4fold.txt > RAB

grep ^"avg" results_4fold.txt > avg

paste mut RAB avg > rxy.txt 
sed -i "s/RAB = //g" rxy.txt
sed -i 's/avg\[2.5%,97.5%\]//g' rxy.txt
sed -i 's/=//g' rxy.txt
sed -i 's/\[//g' rxy.txt
sed -i 's/]//g' rxy.txt
sed -i 's/,//g' rxy.txt
sed -i 's/\t/@/g' rxy.txt
sed -i 's/@/\t/g' rxy.txt

echo -e "mut\trab\tavg\tq25\tq97.5" > RXY.txt
cat rxy.txt >> RXY.txt
