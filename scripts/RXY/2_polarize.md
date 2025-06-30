# Polarize mafs
To polarize I am subsetting the outgroup.maf.gz (HOWA/AMRE), to fixed sites. I will subset the ingroup.maf.gz (cKIWA) to segregating sites. I will then merge these fixed and segregating sites and consider the intersected sites as private to KIWA. 

## Filter mafs
- remove scaffolds and chrz
- Conider only sites where >= 50% of individuals contributes to estimated allele frequency. 
- filter AMRE_HOWA fixed sites and cKIWA segregating sites.  

```bash 
nano $scripts/filter_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Filter Autosomes
# zcat $basedir/cKIWA.mafs.gz | head -1 >> $basedir/priv/cKIWA_auto.mafs
# for i in `cat $scripts/autochrs.txt`; do 
#     zgrep -E "^${i}\b" $basedir/cKIWA.mafs.gz >> $basedir/priv/cKIWA_auto.mafs;
# done

# zcat $basedir/HOWA_AMRE.mafs.gz | head -1 >> $basedir/priv/HOWA_AMRE_auto.mafs
# for i in `cat $scripts/autochrs.txt`; do 
#     zgrep -E "^${i}\b" $basedir/HOWA_AMRE.mafs.gz >> $basedir/priv/HOWA_AMRE_auto.mafs;
# done

#Filter nInd
# awk -v minProp=0.5 -v maxInd=7 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/cKIWA_auto.mafs > $basedir/priv/cKIWA_auto_nind.mafs

# awk -v minProp=0.5 -v maxInd=12 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/HOWA_AMRE_auto.mafs > $basedir/priv/HOWA_AMRE_auto_nind.mafs

#Filter fixed sites AMRE_HOWA
awk '$6 <= 0.01 || $6 >= 0.99' $basedir/priv/HOWA_AMRE_auto_nind.mafs > $basedir/priv/HOWA_AMRE_auto_nind_fixed.mafs

#filter segregating sites cKIWA
awk '$6 > 0.01 && $6 < 0.99' $basedir/priv/cKIWA_auto_nind.mafs > $basedir/priv/cKIWA_auto_nind_segregating.mafs
```

## Obtain cKIWA Private Sites
Find the intersection between outgroup,fixed sites and ingroup,segregating sites to obtain a list of private sites for the ingroup. 

```bash
nano $scripts/cKIWA_private_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=cKIWA_private_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

# #Create BED 
# awk '{print $1,$2-1,$2}' OFS="\t" $basedir/priv/cKIWA_auto_nind_segregating.mafs > $basedir/priv/cKIWA_auto_nind_segregating.bed

# awk '{print $1,$2-1,$2}' OFS="\t" $basedir/priv/HOWA_AMRE_auto_nind_fixed.mafs > $basedir/priv/HOWA_AMRE_auto_nind_fixed.bed

# #Split By Chr
# for i in `cat $scripts/autochrs.txt`; do 
#     grep -E "^${i}\b" $basedir/priv/cKIWA_auto_nind_segregating.bed >> $basedir/priv/cKIWA_auto_nind_segregating_${i}.bed;
# done

# for i in `cat $scripts/autochrs.txt`; do 
#     grep -E "^${i}\b" $basedir/priv/HOWA_AMRE_auto_nind_fixed.bed >> $basedir/priv/HOWA_AMRE_auto_nind_fixed_${i}.bed;
# done

#Intersect 
for i in `cat $scripts/autochrs.txt`; do
    bedtools intersect -a $basedir/priv/cKIWA_auto_nind_segregating_${i}.bed -b $basedir/priv/HOWA_AMRE_auto_nind_fixed_${i}.bed -u >> $basedir/priv/cKIWA_private_unique.bed;
done
```

## Obtain chKIWA Private Sites
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
zcat $basedir/hKIWA.mafs.gz | awk '{print $1,$2-1,$2}' OFS="\t" > $basedir/priv/hKIWA_mafs.bed
sed -i 1d $basedir/priv/hKIWA_mafs.bed

#Split By Chr
for i in `cat $scripts/autochrs.txt`; do 
    grep -E "^${i}\b" $basedir/priv/hKIWA_mafs.bed > $basedir/priv/hKIWA_mafs_${i}.bed;
done

#Find Common Sites
for i in `cat $scripts/autochrs.txt`; do
    bedtools intersect -a $basedir/priv/hKIWA_mafs_${i}.bed -b $basedir/priv/cKIWA_private_unique.bed -u >> $basedir/priv/chKIWA_private.bed;
done
```
