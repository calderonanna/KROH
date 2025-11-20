# Rxy

```bash
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"

#Pop Files
echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > $work/1929IDS.txt
echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > $work/2009IDS.txt
> $work/rxy.txt

for h in h00 h05 h10; do
    cd $work/${h}

    # Define site sets
    bcftools view -H -i 'INFO/S=0' ${h}_fmiss.vcf.gz | cut -f 1,2 > s_0.txt
    bcftools view -H -i 'INFO/S>-0.05 && INFO/S<0' ${h}_fmiss.vcf.gz | cut -f 1,2 > s_05_0.txt
    bcftools view -H -i 'INFO/S>-0.10 && INFO/S<-0.05' ${h}_fmiss.vcf.gz | cut -f 1,2 > s_10_05.txt
    bcftools view -H -i 'INFO/S<-0.10' ${h}_fmiss.vcf.gz | cut -f 1,2 > s_10.txt

    # Run Rxy-kin for each comparison
    $bin/Rxy-kin.py -v ${h}_fmiss.vcf.gz -1 s_0.txt -2 s_05_0.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "-0.05<s<0", h}' OFS="\t" >> $work/rxy.txt

    $bin/Rxy-kin.py -v ${h}_fmiss.vcf.gz -1 s_0.txt -2 s_10_05.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "-0.10<s<-0.05", h}' OFS="\t" >> $work/rxy.txt

    $bin/Rxy-kin.py -v ${h}_fmiss.vcf.gz -1 s_0.txt -2 s_10.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "s<-0.10", h}' OFS="\t" >> $work/rxy.txt
done
