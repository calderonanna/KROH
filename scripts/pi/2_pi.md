```bash
nano $scripts/vcftools_pi.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=200GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=vcftools_pi
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
pi="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pi"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz "

# #Filter VCF
# bcftools view -i 'N_MISSING = 0' $allsites/KIWA_allsites_bi_dp_qual.vcf.gz -Oz -o $allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz 

# #Calculate Pi - Genome Wide 100Kb
# vcftools --gzvcf $vcf --window-pi 100000 --keep $scripts/hKIWA_IDS_e759877.txt --out $pi/gw/hKIWA_gw_100kb

# vcftools --gzvcf $vcf --window-pi 100000 --keep $scripts/cKIWA_IDS.txt --out $pi/gw/cKIWA_gw_100kb

#Calculate Pi - Genome Wide 1bp
vcftools --gzvcf $vcf --site-pi --keep $scripts/hKIWA_IDS_e759877.txt --out $pi/gw/hKIWA_gw_1bp

vcftools --gzvcf $vcf --site-pi --keep $scripts/cKIWA_IDS.txt --out $pi/gw/cKIWA_gw_1bp
```
awk 'NR>1 {sum += $5 * $4; total += $4} END {print "Weighted mean π =", sum/total}' hKIWA_gw.windowed.pi

#Average Pi
awk 'NR>1 {sum=+$3; count++} END {print sum/count}' hKIWA_intergenic.sites.pi

awk 'NR>1 {sum=+$3; count++} END {print sum}' hKIWA_intergenic.sites.pi
