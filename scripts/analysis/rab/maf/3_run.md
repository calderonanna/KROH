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
salloc --nodes=1 --mem=50GB --time=8:00:00 --account=zps5164_cr_default --partition=himem
#activate env
source ~/RABmafs_env/bin/activate

#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
maf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf/tv"
rab="/storage/group/zps5164/default/abc6435/KROH/data/rab/tv"
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous 4fold_synonymous intergenic"
neus="4fold_synonymous intergenic"

#Remove Old Results Files
rm -rf $rab/results.txt

#Run RABmafs
for neu in $neus; do
    for mut in $muts; do
        echo ${mut} >> $rab/${neu}_rab.txt
        python3 $scripts/RABmafs.py --fileA $maf/hKIWA_derived.maf --fileB $maf/cKIWA_derived.maf --fileN $rab/${neu}.txt --fileM $rab/${mut}.txt --seed 645 --psites 0.30 --iter 100 >> $rab/${neu}_rab.txt
        echo "" >> $rab/${neu}_rab.txt
    done
done
```
## Compile Results
```bash
#Data Wrangling
for neu in $neus; do
    yes ${neu} | head -n 8 > $rab/neutral_${neu}

    grep -E '^[a-z]+$|4fold' $rab/${neu}_rab.txt \
    > $rab/muts_${neu}

    grep -E 'RAB =' $rab/${neu}_rab.txt \
    | sed 's/RAB = //' \
    > $rab/RAB_${neu}

    grep -E 'RAB_neutral =' $rab/${neu}_rab.txt \
    | sed 's/RAB_neutral =  //g' \
    > $rab/RAB_neutral_${neu}

    grep 'avg\[2.5%,97.5%\]' $rab/${neu}_rab.txt \
    | sed 's/avg\[2.5%,97.5%\] =  //' \
    | sed 's/ \[ /\t/' \
    | sed 's/ , /\t/' \
    | sed 's/ \]//' \
    > $rab/stats_${neu}

    grep 'N_Sites = ' $rab/${neu}_rab.txt \
    | sed 's/N_Sites =  //g' > $rab/counts_${neu}

    paste $rab/neutral_${neu} $rab/muts_${neu} $rab/RAB_${neu} $rab/RAB_neutral_${neu} $rab/stats_${neu} $rab/counts_${neu} > $rab/results_${neu}.txt
    rm -rf $rab/neutral_${neu} $rab/muts_${neu} $rab/RAB_${neu} $rab/RAB_neutral_${neu} $rab/stats_${neu} $rab/${neu}_rab.txt $rab/counts_${neu}
done

#Compile All Results
cat $rab/results_4fold_synonymous.txt $rab/results_intergenic.txt > $rab/results.txt

rm -rf $rab/results_*.txt