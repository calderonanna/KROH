# Filter
- Filters out cKIWA.mafs and hKIWA.mafs for nInd.

```bash
nano $scripts/filter_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=filter_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
err='/storage/home/abc6435/SzpiechLab/abc6435/KROH/err'

#FILTER SITES
zcat $maf/cKIWA.mafs.gz | awk '$7>=3' > $maf/cKIWA_nInd.maf
zcat $maf/hKIWA.mafs.gz | awk '$7>=3' > $maf/hKIWA_nInd.maf

# awk 'NR==1 {print; next} !((($3=="C" && $4=="T") || ($3=="T" && $4=="C") || ($3=="G" && $4=="A") || ($3=="A" && $4=="G"))) {print}' $maf/cKIWA_nInd.maf >> $maf/cKIWA_nInd_transv.maf

# awk 'NR==1 {print; next} !((($3=="C" && $4=="T") || ($3=="T" && $4=="C") || ($3=="G" && $4=="A") || ($3=="A" && $4=="G"))) {print}' $maf/hKIWA_nInd.maf >> $maf/hKIWA_nInd_transv.maf
```