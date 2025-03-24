# ROH Calling with GARLIC

## Input Files
```bash
salloc --nodes 1 --ntasks 1 --mem=50G --time=9:00:00 
#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"
shared="/storage/home/abc6435/SzpiechLab/shared"

#.tped and .tfam
plink --vcf $data/vcf/$vcf --recode transpose --double-id --chr-set 30 --allow-extra-chr --out $data/roh/garlic/KIWA

awk '$1="kirtlandii"' $data/roh/garlic/KIWA.tfam > $data/roh/garlic/temp && mv -f $data/roh/garlic/temp $data/roh/garlic/KIWA.tfam

#.tgls
$shared/create_tgls_from_vcf.py $data/vcf/$vcf > $data/roh/garlic/KIWA.tgls

#centromere.txt
bcftools query -f '%CHROM\n' $data/vcf/$vcf_c | uniq > $data/roh/garlic/centromere.txt

awk '$1=$1" 0 1"' $data/roh/garlic/centromere.txt > $data/roh/garlic/temp && mv -f $data/roh/garlic/temp $data/roh/garlic/centromere.txt
```

## Run GARLIC
```bash
#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"
centromere="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic/centromere.txt"

#run 
garlic --auto-winsize --auto-overlap-frac --winsize 100 --tped $work_dir/KIWA.tped --tfam $work_dir/KIWA.tfam --tgls $work_dir/KIWA.tgls --gl-type GQ --resample 40 --centromere $centromere --size-bounds 1000000 2000000 3000000 4000000 5000000 --out $work_dir/KIWA

#Remove any ROH < 0.5MB
cat $work_dir/KIWA.roh.bed  | awk -F '\t' '$5>500000 || /track/ {print$0}' > $work_dir/KIWA_0.5MB.roh.bed
```

## ROH Summary
```bash
#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"
shared="/storage/home/abc6435/SzpiechLab/shared"

#Create ID File
sed 's/ /\t/g' $work_dir/KIWA.tfam | cut -f1,2 >> $work_dir/ids.txt
awk '{print $2, $1}' $work_dir/ids.txt > $work_dir/temp && mv -f $work_dir/temp $work_dir/ids.txt

#Calculate ROH Fractions
$shared/calculate_ROH_fractions.pl $work_dir/KIWA.roh.bed 6 $work_dir/ids.txt > $work_dir/KIWA_roh_sum.txt
$shared/calculate_ROH_fractions.pl $work_dir/KIWA_0.5MB.roh.bed 6 $work_dir/ids.txt > $work_dir/KIWA_roh_sum_0.5MB.txt