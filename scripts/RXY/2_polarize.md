ingroup_polymorphic.maf.bed
outgroup_fixed.maf.bed

bcftools intersect -a ingroup_polymorphic.maf -b outgroup_fixed.maf > KIWA_private.maf.bed
# Polarize mafs
To polarize I am subsetting the outgroup.maf.gz (HOWA/AMRE), to fixed sites. I will subset the ingroup.maf.gz (cKIWA) to segregating sites. I will then merge these fixed and segregating sites and consider the intersected sites as private to KIWA. 

## Filter mafs
- remove scaffolds and chrz
- Conider only sites where >= 50% of individuals contributes to estimated allele frequency. 
- allele frequency cut offs. Define what is considered fixed vs segregating. 

```bash 
nano $scripts/filter_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Filter Autosomes
zcat $basedir/cKIWA.mafs.gz | head -1 >> $basedir/priv/cKIWA_auto.mafs
for i in `cat $scripts/autochrs.txt`; do 
    zgrep -E "^${i}\b" $basedir/cKIWA.mafs.gz >> $basedir/priv/cKIWA_auto.mafs;
done

# zcat $basedir/HOWA_AMRE.mafs.gz | head -1 >> $basedir/priv/HOWA_AMRE_auto.mafs
# for i in `cat $scripts/autochrs.txt`; do 
#     zgrep -E "^${i}\b" $basedir/HOWA_AMRE.mafs.gz >> $basedir/priv/HOWA_AMRE_auto.mafs;
# done

#Filter nInd
awk -v minProp=0.5 -v maxInd=7 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/cKIWA_auto.mafs > $basedir/priv/cKIWA_auto_nind.mafs

# awk -v minProp=0.5 -v maxInd=12 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/HOWA_AMRE_auto.mafs > $basedir/priv/HOWA_AMRE_auto_nind.mafs

