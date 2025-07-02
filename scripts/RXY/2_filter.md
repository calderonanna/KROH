# Filter mafs
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
zcat $basedir/cKIWA.mafs.gz | head -1 >> $basedir/priv/cKIWA_auto.mafs
for i in `cat $scripts/autochrs.txt`; do 
    zgrep -E "^${i}\b" $basedir/cKIWA.mafs.gz >> $basedir/priv/cKIWA_auto.mafs;
done

zcat $basedir/HOWA_AMRE.mafs.gz | head -1 >> $basedir/priv/HOWA_AMRE_auto.mafs
for i in `cat $scripts/autochrs.txt`; do 
    zgrep -E "^${i}\b" $basedir/HOWA_AMRE.mafs.gz >> $basedir/priv/HOWA_AMRE_auto.mafs;
done

#Filter nInd
awk -v minProp=0.5 -v maxInd=7 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/cKIWA_auto.mafs > $basedir/priv/cKIWA_auto_nind.mafs

awk -v minProp=0.5 -v maxInd=12 'NR==1 || $7 >= (minProp * maxInd)' $basedir/priv/HOWA_AMRE_auto.mafs > $basedir/priv/HOWA_AMRE_auto_nind.mafs

#Filter fixed sites HOWA_AMRE
awk '$6 <= 0.01 || $6 >= 0.99' $basedir/priv/HOWA_AMRE_auto_nind.mafs > $basedir/priv/HOWA_AMRE_auto_nind_fixed.mafs

#filter segregating sites cKIWA
awk '$6 > 0.01 && $6 < 0.99' $basedir/priv/cKIWA_auto_nind.mafs > $basedir/priv/cKIWA_auto_nind_segregating.mafs
```
