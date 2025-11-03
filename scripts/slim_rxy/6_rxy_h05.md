# Rxy h05

```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
cd $work/h05

bcftools view -H -i 'INFO/S=0' h05_fmiss.vcf.gz \
| cut -f 1,2 > s_0.txt

bcftools view -H -i 'INFO/S>-0.0025 && INFO/S<0' h05_fmiss.vcf.gz | cut -f 1,2 > s_0025_0.txt 

bcftools view -H -i 'INFO/S>-0.005 && INFO/S<-0.0025' h05_fmiss.vcf.gz | cut -f 1,2 > s_0050_0025.txt 

bcftools view -H -i 'INFO/S<-0.005' h05_fmiss.vcf.gz | cut -f 1,2 > s_0050.txt 

#Pop Files
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt


#Rxy-kin
cd $work/h05

$bin/Rxy-kin.py -v h05_fmiss.vcf.gz -1 s_0.txt -2 s_0025_0.txt  -A 1929IDS.txt -B 2009IDS.txt \
| awk '{print $0, "-0.0025<s<0", "h=0.5"}' OFS="\t" \
>> $work/rxy.txt

$bin/Rxy-kin.py -v h05_fmiss.vcf.gz -1 s_0.txt -2 s_0050_0025.txt  -A 1929IDS.txt -B 2009IDS.txt \
| awk '{print $0, "-0.0050<s<-0.0025", "h=0.5"}' OFS="\t" \
>> $work/rxy.txt

$bin/Rxy-kin.py -v h05_fmiss.vcf.gz -1 s_0.txt -2 s_0050.txt  -A 1929IDS.txt -B 2009IDS.txt \
| awk '{print $0, "s<-0.0050", "h=0.5"}' OFS="\t" \
>> $work/rxy.txt
