# Polarize mafs
To polarize I am subsetting the outgroup.maf.gz (HOWA/AMRE), to fixed sites. I will subset the ingroup.maf.gz (cKIWA) to segregating sites. I will then merge these fixed and segregating sites and consider the intersected sites as private to cKIWA. Then I will find the intersection between cKIWA and hKIWA and this will subset all private sites for all KIWA samples. 

```bash
nano $scripts/chKIWA_private_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=chKIWA_private_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Create BED 
awk '{print $1,$2-1,$2}' OFS="\t" $basedir/priv/cKIWA_auto_nind_segregating.mafs > $basedir/priv/cKIWA_auto_nind_segregating.bed

awk '{print $1,$2-1,$2}' OFS="\t" $basedir/priv/HOWA_AMRE_auto_nind_fixed.mafs > $basedir/priv/HOWA_AMRE_auto_nind_fixed.bed

#Split By Chr
for i in `cat $scripts/autochrs.txt`; do 
    grep -E "^${i}\b" $basedir/priv/cKIWA_auto_nind_segregating.bed >> $basedir/priv/cKIWA_auto_nind_segregating_${i}.bed;
done

for i in `cat $scripts/autochrs.txt`; do 
    grep -E "^${i}\b" $basedir/priv/HOWA_AMRE_auto_nind_fixed.bed >> $basedir/priv/HOWA_AMRE_auto_nind_fixed_${i}.bed;
done

#Intersect 
for i in `cat $scripts/autochrs.txt`; do
    bedtools intersect -a $basedir/priv/cKIWA_auto_nind_segregating_${i}.bed -b $basedir/priv/HOWA_AMRE_auto_nind_fixed_${i}.bed -u >> $basedir/priv/cKIWA_private_${i}.bed;
done

# Intersect cKIWA and hKIWA
zcat $basedir/hKIWA.mafs.gz | awk '{print $1,$2-1,$2}' OFS="\t" > $basedir/priv/hKIWA_mafs.bed
sed -i 1d $basedir/priv/hKIWA_mafs.bed

for i in `cat $scripts/autochrs.txt`; do 
    grep -E "^${i}\b" $basedir/priv/hKIWA_mafs.bed > $basedir/priv/hKIWA_mafs_${i}.bed;
done

for i in `cat $scripts/autochrs.txt`; do
    bedtools intersect -a $basedir/priv/cKIWA_private_${i}.bed -b $basedir/priv/hKIWA_mafs_${i}.bed -u >> $basedir/private_sites/chKIWA_private_${i}.bed;
done

for i in `cat $scripts/autochrs.txt`; do
    cat $basedir/priv/cKIWA_private_${i}.bed >> $basedir/private_sites/chKIWA_private.bed;
done
```