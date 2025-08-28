# Derived Mutations

## Upload Mutations DB
```bash
scp /Users/annamariacalderon/Desktop/KROH/data/rxy/* abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/muts
```
## Extract Derived Mutations
```bash
nano $scripts/derived_mutations.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=derived_mutations
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
mutations="deleterious tolerated lossoffunction noncoding nonsynonymous synonymous"

# #Create Keys
# for i in `cat $scripts/autochrs.txt`; do
#     grep -E "^${i}\b" $basedir/polar/chKIWA_der.mafs | awk '{print $0,$1"_"$2}' OFS="\t" >> $basedir/polar/chKIWA_der_${i}.keyvalues;
# done

# for i in $(echo $mutations); do
#     awk '{print $1"_"$2}' OFS="\t" $basedir/muts/${i}.txt > $basedir/muts/${i}.keys;
# done

# # Extract
# for i in `cat $scripts/autochrs.txt`; do
#     for j in $(echo $mutations); do
#         awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/polar/chKIWA_der_${i}.keyvalues $basedir/muts/${j}.keys >> $basedir/muts/chKIWA_der_${j}.temp;
#     done;
# done

# #Create Keys for derived mutations
# for i in $(echo $mutations); do
#     cut -f 8 $basedir/muts/chKIWA_der_${i}.temp >> $basedir/muts/chKIWA_der_${i}.key;
# done

#Create Keys for cKIWA.maf and hKIWA.maf
for i in `cat $scripts/autochrs.txt`; do
    zgrep -E "^${i}\b" $basedir/mafs/cKIWA.mafs.gz | awk '{print $0,$1"_"$2}' OFS="\t" >> $basedir/mafs/cKIWA_${i}.keyvalues
    zgrep -E "^${i}\b" $basedir/mafs/hKIWA.mafs.gz | awk '{print $0,$1"_"$2}' OFS="\t" >> $basedir/mafs/hKIWA_${i}.keyvalues; 
done

for i in `cat $scripts/autochrs.txt`; do
    for j in $(echo $mutations); do
        awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/cKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_${j}.key >> $basedir/mafs/cKIWA_der_${j}.temp
        awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/hKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_${j}.key >> $basedir/mafs/hKIWA_der_${j}.temp;
    done;
done
```