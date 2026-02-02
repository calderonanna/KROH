# Rxy

```bash
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs"

#Pop Files

echo -e "i0_1929_eggs\ni1_1929_eggs\ni2_1929_eggs\ni3_1929_eggs\ni4_1929_eggs\ni5_1929_eggs\ni6_1929_eggs" > $work/1929IDS.txt
echo -e "i0_2009_eggs\ni1_2009_eggs\ni2_2009_eggs\ni3_2009_eggs\ni4_2009_eggs\ni5_2009_eggs\ni6_2009_eggs" > $work/2009IDS.txt

for h in h00 h05 h10; do
    cd $work/${h}

    # Define site sets
    bcftools view -H -i 'INFO/S=0' ${h}_eggs_fmiss.vcf.gz | cut -f 1,2 > s_0.txt
    bcftools view -H -i 'INFO/S>-0.05 && INFO/S<0' ${h}_eggs_fmiss.vcf.gz | cut -f 1,2 > s_05_0.txt
    bcftools view -H -i 'INFO/S>-0.10 && INFO/S<-0.05' ${h}_eggs_fmiss.vcf.gz | cut -f 1,2 > s_10_05.txt
    bcftools view -H -i 'INFO/S<-0.10' ${h}_eggs_fmiss.vcf.gz | cut -f 1,2 > s_10.txt

    # Run Rxy-kin for each comparison
    $bin/Rxy-kin.py -v ${h}_eggs_fmiss.vcf.gz -1 s_0.txt -2 s_05_0.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "-0.05<s<0", h}' OFS="\t" >> $work/rxy.txt

    $bin/Rxy-kin.py -v ${h}_eggs_fmiss.vcf.gz -1 s_0.txt -2 s_10_05.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "-0.10<s<-0.05", h}' OFS="\t" >> $work/rxy.txt

    $bin/Rxy-kin.py -v ${h}_eggs_fmiss.vcf.gz -1 s_0.txt -2 s_10.txt -A $work/1929IDS.txt -B $work/2009IDS.txt \
    | awk -v h="$h" '{print $0, "s<-0.10", h}' OFS="\t" >> $work/rxy.txt
done
