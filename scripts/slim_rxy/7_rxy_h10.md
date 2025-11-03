# Rxy h10

```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
cd $work/h10

bcftools view -H -i 'INFO/S=0' h10_fmiss.vcf.gz \
| cut -f 1,2 > s_0.txt

bcftools view -H -i 'INFO/S>-0.0025 && INFO/S<0' h10_fmiss.vcf.gz | cut -f 1,2 > s_0025_0.txt 

bcftools view -H -i 'INFO/S<-0.0025' h10_fmiss.vcf.gz | cut -f 1,2 > s_0025.txt 

#Pop Files
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt

#Rxy-kin
$bin/Rxy-kin.py -v h10_fmiss.vcf.gz -1 s_0.txt -2 s_0025_0.txt  -A 1929IDS.txt -B 2009IDS.txt \
| awk '{print $0, "-0.0025<s<0", "h=1.0"}' OFS="\t" \
>> $work/rxy.txt

$bin/Rxy-kin.py -v h10_fmiss.vcf.gz -1 s_0.txt -2 s_0025.txt  -A 1929IDS.txt -B 2009IDS.txt \
| awk '{print $0, "s<-0.0025", "h=1.0"}' OFS="\t" \
>> $work/rxy.txt


sed -i 's/ /\t/g' $work/rxy.txt