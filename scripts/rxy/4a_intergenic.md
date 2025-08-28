# Intergenic Sites

```bash
nano $scripts/intergenic_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=intergenic_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
workdir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Concatenate Mutations
muts="deleterious lossoffunction noncoding nonsynonymous synonymous tolerated"

for i in $(echo $muts); do
    sed 1d ${i}.txt >> $workdir/muts/genic.temp;
done

cat deleterious.txt | head -1 >> genic.txt

for i in `cat $scripts/autochrs.txt`; do
    grep -E "^${i}\b" $workdir/muts/genic.temp | sort -k2,2n | uniq >> $workdir/muts/genic.txt;
done

rm -rf $workdir/muts/genic.temp

#Extract Intergenic Sites
grep -v -f $workdir/muts/genic.txt $workdir/polar/chKIWA_derived.txt >> $workdir/muts/intergenic.txt

#Sample Sites
cat $workdir/muts/intergenic.txt | shuf -n 5000000 > $workdir/muts/intergenic5M_set1.temp
cat deleterious.txt | head -1 >> intergenic5M_set1.txt
for i in `cat $scripts/autochrs.txt`; do
    grep -E "^${i}\b" $workdir/muts/intergenic5M_set1.temp | sort -k2,2n | uniq >> $workdir/muts/intergenic5M_set1.txt;
done
rm -rf $workdir/muts/intergenic5M_set1.temp

