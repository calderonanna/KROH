## Filter Ancestral Allele
Defined as sites in the outgroup (HOWA_AMRE), where the major allele is the same as reference allele AND is also fixed

```bash
nano $scripts/polarize.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=polarize
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

# Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

# # Maj = Ref && Maj > 0.99 (Min < 0.01)
# awk '$3 == $5 && $6 < 0.01' $basedir/mafs/HOWA_AMRE_auto_nind.mafs >> $basedir/polar/HOWA_AMRE_auto_nind_maj_ref_fixed.mafs

# Create Keys
# for i in `cat $scripts/autochrs.txt`; do
#     grep -E "^${i}\b" $basedir/polar/HOWA_AMRE_auto_nind_maj_ref_fixed.mafs | awk '{print $1"_"$2}' >> $basedir/polar/HOWA_AMRE_maj_ref_fixed_${i}.key; 
# done

for i in `cat $scripts/autochrs.txt`; do
    grep -E "^${i}\b" $basedir/mafs/chKIWA_auto_nind.mafs | awk '{print $0,$1"_"$2}' OFS="\t" >> $basedir/polar/chKIWA_${i}.keyvalues;
done

# Extract
for i in `cat $scripts/autochrs.txt`; do
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/polar/chKIWA_${i}.keyvalues $basedir/polar/HOWA_AMRE_maj_ref_fixed_${i}.key >> $basedir/polar/chKIWA_anc_der.mafs;
done

# Subset segreating MAF
cut -f 1-7 $basedir/polar/chKIWA_anc_der.mafs | awk '$6>0.01' >> $basedir/polar/chKIWA_der.mafs
```