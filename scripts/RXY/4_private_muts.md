# Private Mutations

## Upload Mutations DB
```bash
scp /Users/annamariacalderon/Desktop/KROH/data/rxy/* abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/private_mutations
```

## Intersect Private Sites
```bash
nano $scripts/intersect_mutations.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=11:00:00
#SBATCH --account=open
#SBATCH --job-name=intersect_private_mutations
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Create BED
mutations="deleterious tolerated lossoffunction noncoding nonsynonymous synonymous"
for i in $(echo $mutations); do
    awk '{print $1,$2-1,$2}' OFS="\t" $basedir/private_mutations/${i}.txt | sed 1d > $basedir/private_mutations/${i}.bed;
done

#Intersect With Private Sites
for i in $(echo $mutations); do
    bedtools intersect -a $basedir/private_mutations/${i}.bed -b $basedir/private_sites/chKIWA_private.bed > $basedir/private_mutations/chKIWA_${i}.bed;
done
```

## Subset MAFs
using the chKIWA_mutation.bed, subset both cKIWA.mafs.gz and hKIWA.mafs.gz. So there should be a total of 12 files c/hKIWA_mutation.mafs.gz