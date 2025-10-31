# Data Wrangling

## Upload VCFs
```bash 
scp /Users/abc6435/Desktop/KROH/data/slim/rxy/h00/h00_*.vcf abc6435@submit.hpc.psu.edu://storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/h00

```
## Data Wrangling
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
cd $work/h00 

# Reheader Sample Names
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt

bcftools reheader --samples 1929IDS.txt h00_1929.vcf -o h00_1929_reheadered.vcf
bcftools reheader --samples 2009IDS.txt h00_2009.vcf -o h00_2009_reheadered.vcf

#Zip and Index
bgzip h00_1929_reheadered.vcf
bgzip h00_2009_reheadered.vcf
bcftools index h00_1929_reheadered.vcf.gz
bcftools index h00_2009_reheadered.vcf.gz

# Merge VCFs and Filter
bcftools merge h00_1929_reheadered.vcf.gz h00_2009_reheadered.vcf.gz -Oz -o h00_chr1.vcf.gz
bcftools view -i 'F_MISSING == 0' h00_chr1.vcf.gz -Oz -o h00_fmiss.vcf.gz

#File Clean Up
rm -rf *1929* *2009* h00_chr1.vcf.gz

#Obtain selection coefficients
bcftools query -f '%INFO/S' $work/h00/h00_fmiss.vcf.gz > $work/h00/h00_s.txt
```