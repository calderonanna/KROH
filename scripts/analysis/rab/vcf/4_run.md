# Calculate RAB

## Install Python Packages
```bash
#install python packages
python3 -m venv ~/RABvcfs_env
source ~/RABvcfs_env/bin/activate
pip install --upgrade pip
pip install pandas numpy argparse
```

## Run RABmafs.py
```bash
nano $scripts/rabvcfs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=200:00:00
#SBATCH --account=open
#SBATCH --partition=himem
#SBATCH --job-name=RABvcfs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#activate env
source ~/RABvcfs_env/bin/activate

#Set Variables
rab='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rab/vcf'
vcf='/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf'
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous"
neus="4fold_synonymous intergenic"

#Remove Old Results Files
rm -rf $rab/results.txt $rab/der_mut_counts.txt

#Run RABmafs
for neu in $neus; do
    for mut in $muts; do
        echo ${mut} >> $rab/${neu}_rab.txt
        python3 $scripts/RABvcfs.py --vcf $vcf --pop $scripts/pops.txt --fileN $rab/${neu}.txt --fileM $rab/${mut}.txt --seed 89 --psites 0.30 --iter 100 >> $rab/${neu}_rab.txt
        echo "" >> $rab/${neu}_rab.txt
    done
done

#Derived Mutation Counts
for mut in $muts; do
    echo ${mut} >> $rab/derived_mutation_counts.tmp;
done

grep "Number of" $rab/intergenic_rab.txt >> $rab/derived_mutation_counts.tmp2

paste $rab/derived_mutation_counts.tmp $rab/derived_mutation_counts.tmp2 > $rab/der_mut_counts.txt

rm -rf $rab/derived_mutation_counts.tmp*


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
sed -i '1d' $rab/results_intergenic.txt
cat $rab/results_4fold_synonymous.txt $rab/results_intergenic.txt >> $rab/results.txt

rm -rf $rab/results_*.txt