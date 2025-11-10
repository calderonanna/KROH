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

#Filter VCF
bcftools view -i 'N_MISSING = 0' $allsites/KIWA_allsites_bi_dp_qual.vcf.gz -Oz -o $allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz 

#Calculate Pi - Intergenic Sites
vcftools --gzvcf $vcf --positions $pi/intergenic.txt --site-pi --keep $scripts/hKIWA_IDS_e759877.txt --out $pi/inter/hKIWA_intergenic

vcftools --gzvcf $vcf --positions $pi/intergenic.txt --site-pi --keep $scripts/cKIWA_IDS.txt --out $pi/inter/cKIWA_intergenic

#Calculate Pi - Genome Wide
vcftools --gzvcf $vcf --window-pi 100000 --keep $scripts/hKIWA_IDS_e759877.txt --out $pi/gw/hKIWA_gw

vcftools --gzvcf $vcf --window-pi 100000 --keep $scripts/cKIWA_IDS.txt --out $pi/gw/cKIWA_gw
```

#Average Pi
awk 'NR>1 {sum=+$3; count++} END {print sum/count}' hKIWA_intergenic.sites.pi
