# ROH Calling with GARLIC

## Input Files
```bash
salloc --nodes 1 --ntasks 1 --mem=50G --time=9:00:00 

#Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
vcf="chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet.vcf.gz"
shared="/storage/home/abc6435/SzpiechLab/shared"

cd $work_dir

#.tped and .tfam
plink --vcf $vcf_dir/$vcf --recode transpose --double-id --chr-set 30 --allow-extra-chr --out KIWA

awk '$1="kirtlandii"' KIWA.tfam > temp && mv -f temp KIWA.tfam

#.tgls
$shared/create_tgls_from_vcf.py $vcf_dir/$vcf > KIWA.tgls

#centromere.txt
bcftools query -f \
    '%CHROM\n' $vcf_dir/$vcf \
    | uniq > centromere.txt

awk '$1=$1" 0 1"' centromere.txt > temp && mv -f temp centromere.txt
```

## Run GARLIC
```bash
#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"
centromere="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic/centromere.txt"

#run 
garlic --auto-winsize true --overlap-frac 0.05 --max-gap 1000000 --winsize 100 --tped $work_dir/KIWA.tped --tfam $work_dir/KIWA.tfam --tgls $work_dir/KIWA.tgls --gl-type GQ --resample 100 --centromere $centromere --size-bounds 1000000 2000000 3000000 4000000 5000000 --out $work_dir/KIWA

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