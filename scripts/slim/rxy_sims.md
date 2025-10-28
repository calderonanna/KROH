# Rxy Simulations

## Upload VCFs
```bash 
#Set Variables
dom="dom_1_0"

#Upload
scp /Users/abc6435/Desktop/KROH/data/slim/rxy/slim_chr1_1929.vcf abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/$dom

scp /Users/abc6435/Desktop/KROH/data/slim/rxy/slim_chr1_2009.vcf abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/$dom
```
## Data Wrangling
```bash
#Set Variables
dom="dom_1_0"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/$dom"
cd $work 

# Reheader Sample Names
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
bcftools reheader --samples 1929IDS.txt slim_chr1_1929.vcf -o slim_chr1_1929_reheadered.vcf
bgzip slim_chr1_1929_reheadered.vcf
bcftools index slim_chr1_1929_reheadered.vcf.gz

echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt
bcftools reheader --samples 2009IDS.txt slim_chr1_2009.vcf -o slim_chr1_2009_reheadered.vcf
bgzip slim_chr1_2009_reheadered.vcf
bcftools index slim_chr1_2009_reheadered.vcf.gz

# Merge VCFs and Filter
bcftools merge slim_chr1_1929_reheadered.vcf.gz slim_chr1_2009_reheadered.vcf.gz -Oz -o slim_chr1.vcf.gz
bcftools view -i 'F_MISSING == 0' slim_chr1.vcf.gz -Oz -o slim_chr1_fmiss.vcf.gz

#File Clean Up
rm -rf *1929* *2009* slim_chr1.vcf.gz
```

## Calculate Rxy
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"

#Neutral Sites (double check)
bcftools view -H -i 'INFO/S=0' slim_chr1_fmiss.vcf.gz | cut -f 1,2 > neu.txt
bcftools view -H -i 'INFO/S<0' slim_chr1_fmiss.vcf.gz | cut -f 1,2 > del.txt

#Pop Files
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt

#Rxy-kin
$bin/Rxy-kin.py -v slim_chr1_fmiss.vcf.gz -1 del.txt -2 neu.txt -A 1929IDS.txt -B 2009IDS.txt
```
