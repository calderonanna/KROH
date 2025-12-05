## gatk MergeVCFs
```bash
nano $scripts/gatk_merge.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=gatk_merge
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
vcfs=$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites/*.vcf.gz | sed 's/^/-I /')

#MergeVcfs
gatk MergeVcfs \
    $vcfs \
    -O $allsites/dKIWA_allsites.vcf.gz
```