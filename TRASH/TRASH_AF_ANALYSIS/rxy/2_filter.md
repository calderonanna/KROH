# Filter mafs
- remove scaffolds and chrz
- Conider only sites where >= 50% of individuals contributes to estimated allele frequency.  

```bash 
nano $scripts/filter_mafs_auto_nind.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=filter_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/mafs'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Filter Autosomes chKIWA
zcat $basedir/chKIWA.mafs.gz | head -1 >> $basedir/chKIWA_auto.mafs

for i in `cat $scripts/autochrs.txt`; do 
    zgrep -E "^${i}\b" $basedir/chKIWA.mafs.gz >> $basedir/chKIWA_auto.mafs;
done

#Filter Autosomes HOWA_AMRE
zcat $basedir/HOWA_AMRE.mafs.gz | head -1 >> $basedir/HOWA_AMRE_auto.mafs

for i in `cat $scripts/autochrs.txt`; do 
    zgrep -E "^${i}\b" $basedir/HOWA_AMRE.mafs.gz >> $basedir/HOWA_AMRE_auto.mafs;
done

#Filter nInd chKIWA
awk -v minProp=0.5 -v maxInd=13 'NR==1 || $7 >= (minProp * maxInd)' $basedir/chKIWA_auto.mafs > $basedir/chKIWA_auto_nind.mafs

#Filter nInd AMRE_HOWA
awk -v minProp=0.5 -v maxInd=12 'NR==1 || $7 >= (minProp * maxInd)' $basedir/HOWA_AMRE_auto.mafs > $basedir/HOWA_AMRE_auto_nind.mafs
```