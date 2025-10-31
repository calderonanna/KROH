## Calculate Rxy
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"

#S=0
bcftools view -H -i 'INFO/S=0' h00_fmiss.vcf.gz | cut -f 1,2 > s_000.txt

#-0.02<S<0
bcftools view -H -i 'INFO/S>-0.02 && INFO/S<0' h00_fmiss.vcf.gz | cut -f 1,2 > s_-002_0.txt 

#-0.04<S<-0.02
bcftools view -H -i 'INFO/S>-0.04 && INFO/S<-0.02' h00_fmiss.vcf.gz | cut -f 1,2 > s_-004_-002.txt 

#-0.06<S<-0.04
bcftools view -H -i 'INFO/S>-0.06 && INFO/S<-0.04' h00_fmiss.vcf.gz | cut -f 1,2 > s_-006_-004.txt 

#-0.08<S<-0.06
bcftools view -H -i 'INFO/S>-0.08 && INFO/S<-0.06' h00_fmiss.vcf.gz | cut -f 1,2 > s_-008_-006.txt 

#-0.10<S<-0.08
bcftools view -H -i 'INFO/S>-0.10 && INFO/S<--0.08' h00_fmiss.vcf.gz | cut -f 1,2 > s_-010_-008.txt 

#Pop Files
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt

#Rxy-kin
echo "-0.02<S<0" >> rxy.txt
$bin/Rxy-kin.py -v h00_fmiss.vcf.gz -1 s_000.txt -2 s_-002_0.txt -A 1929IDS.txt -B 2009IDS.txt >> rxy.txt
echo "" >> rxy.txt

echo "-0.04<S<-0.02" >> rxy.txt
$bin/Rxy-kin.py -v h00_fmiss.vcf.gz -1 s_000.txt -2 s_-004_-002.txt -A 1929IDS.txt -B 2009IDS.txt >> rxy.txt
echo "" >> rxy.txt

echo "-0.06<S<-0.04" >> rxy.txt
$bin/Rxy-kin.py -v h00_fmiss.vcf.gz -1 s_000.txt -2 s_-006_-004.txt -A 1929IDS.txt -B 2009IDS.txt >> rxy.txt
echo "" >> rxy.txt

echo "-0.08<S<-0.06" >> rxy.txt
$bin/Rxy-kin.py -v h00_fmiss.vcf.gz -1 s_000.txt -2 s_-008_-006.txt -A 1929IDS.txt -B 2009IDS.txt >> rxy.txt
echo "" >> rxy.txt

echo "-0.10<S<-0.08" >> rxy.txt
$bin/Rxy-kin.py -v h00_fmiss.vcf.gz -1 s_000.txt -2 s_-010_-008.txt -A 1929IDS.txt -B 2009IDS.txt >> rxy.txt
echo "" >> rxy.txt
```
