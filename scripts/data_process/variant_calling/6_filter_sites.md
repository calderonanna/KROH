## Filter Sites
```bash
nano $scripts/filter_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=10:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"

#Count Sites
echo "dSETO.vcf.gz" >> $gatk/vcf/log/snps.log
zgrep -v ^## $gatk/vcf/dSETO.vcf.gz | wc -l >> $gatk/vcf/log/snps.log
echo "" >> $gatk/vcf/log/snps.log

#Biallelic Sites
bcftools view -m2 -M2 -v snps $gatk/vcf/dSETO.vcf.gz -Oz -o $gatk/vcf/dSETO_bi.vcf.gz
echo "dSETO_bi.vcf.gz" >> $gatk/vcf/log/snps.log
zgrep -v ^## $gatk/vcf/dSETO_bi.vcf.gz | wc -l >> $gatk/vcf/log/snps.log
echo "" >> $gatk/vcf/log/snps.log

#Site Quality
bcftools view -i 'QUAL>=50' $gatk/vcf/dSETO_bi.vcf.gz -Oz -o $gatk/vcf/dSETO_bi_qual.vcf.gz
echo "dSETO_bi_qual.vcf.gz" >> $gatk/vcf/log/snps.log
zgrep -v ^## $gatk/vcf/dSETO_bi_qual.vcf.gz | wc -l >> $gatk/vcf/log/snps.log
echo "" >> $gatk/vcf/log/snps.log
```