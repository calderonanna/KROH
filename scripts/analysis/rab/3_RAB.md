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
#activate env
source ~/RABmafs_env/bin/activate

#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
maf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf"
rab="/storage/group/zps5164/default/abc6435/KROH/data/rab"
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous"
neus="4fold_synonymous intergenic"

#run RABmafs
for neu in $neus; do
    for mut in $muts; do
        echo ${mut} >> $rab/${neu}_rab.txt
        python3 $scripts/RABmafs.py --fileA $maf/hKIWA_derived.maf --fileB $maf/cKIWA_derived.maf --fileN $rab/${neu}.txt --fileM $rab/${mut}.txt --seed 100 --psites 0.30 --iter 20 >> $rab/${neu}_rab.txt
        echo "" >> $rab/${neu}_rab.txt
    done
done

#Data Wrangling
for neu in $neus; do
    echo -e "NEUTRAL\tMUT\tRAB\tRAB_NEUTRAL\tAVG\tQ25\tQ97" > $rab/results_${neu}.txt
    yes ${neu} | head -n 6 > $rab/neutral_${neu}

    grep -E '^[a-z]+$' $rab/${neu}_rab.txt \
    > $rab/muts_${neu}

    grep -E 'RAB =' $rab/${neu}_rab.txt \
    | sed 's/RAB = //' \
    > $rab/RAB_${neu}

    grep -E 'RAB_neutral =' $rab/${neu}_rab.txt \
    | sed 's/RAB_neutral =  //' \
    > $rab/RAB_neutral_${neu}

    grep 'avg\[2.5%,97.5%\]' $rab/${neu}_rab.txt \
    | sed 's/avg\[2.5%,97.5%\] =  //' \
    | sed 's/ \[ /\t/' \
    | sed 's/ , /\t/' \
    | sed 's/ \]//' \
    > $rab/stats_${neu}

    paste $rab/neutral_${neu} $rab/muts_${neu} $rab/RAB_${neu} $rab/RAB_neutral_${neu} $rab/stats_${neu} >> $rab/results_${neu}.txt

    rm -rf $rab/neutral_${neu} $rab/muts_${neu} $rab/RAB_${neu} $rab/RAB_neutral_${neu} $rab/stats_${neu} $rab/${neu}_rab.txt
done

#Compile All Results
sed -i '1d' results_intergenic.txt
cat results_4fold_synonymous.txt results_intergenic.txt >> results.txt

rm results_*.txt