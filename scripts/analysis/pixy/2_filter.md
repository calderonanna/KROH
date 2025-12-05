# Filter VCF
```bash
nano $scripts/pixy_filter.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=6:00:00
#SBATCH --account=open
#SBATCH --job-name=pixy_filter
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#Filter Sites and Index
bcftools view -M2 -i '((ALT="." && INFO/DP>10) || (ALT!="." && STRLEN(REF)==1 && STRLEN(ALT)==1 && INFO/DP>10 && QUAL>=30))' $allsites/dKIWA_allsites.vcf.gz -Oz -o $allsites/dKIWA_allsites_bi_dp_qual.vcf.gz

nohup tabix $allsites/dKIWA_allsites_bi_dp_qual.vcf.gz