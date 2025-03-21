# ROH Calling with GARLIC

## Create .tfam and .tped
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf_h="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.h.vcf.gz"
vcf_c="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.c.vcf.gz"

plink --vcf $data/vcf/$vcf_c --recode transpose --double-id --chr-set 30 --allow-extra-chr --out $data/roh/garlic/cKIWA/c
awk '$1="kirtlandii"' $data/roh/garlic/cKIWA/c.tfam > $data/roh/garlic/cKIWA/temp && mv -f $data/roh/garlic/cKIWA/temp $data/roh/garlic/cKIWA/c.tfam


plink --vcf $data/vcf/$vcf_h --recode transpose --double-id --chr-set 30 --allow-extra-chr --out $data/roh/garlic/hKIWA/h
awk '$1="kirtlandii"' $data/roh/garlic/hKIWA/h.tfam > $data/roh/garlic/hKIWA/temp && mv -f $data/roh/garlic/hKIWA/temp $data/roh/garlic/hKIWA/h.tfam

```

## Create .tgls
```bash
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf_h="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.h.vcf.gz"
vcf_c="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.c.vcf.gz"
shared="/storage/home/abc6435/SzpiechLab/shared"

$shared/create_tgls_from_vcf.py $data/vcf/$vcf_h > $data/roh/garlic/hKIWA/h.tgls

$shared/create_tgls_from_vcf.py $data/vcf/$vcf_c > $data/roh/garlic/cKIWA/c.tgls
```

## Create a Centromere File
If you don't have a centromere file, then create a dummy one
```bash
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf_h="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.h.vcf.gz"
vcf_c="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.c.vcf.gz"
shared="/storage/home/abc6435/SzpiechLab/shared"


bcftools query -f '%CHROM\n' $data/vcf/$vcf_c | uniq > $data/roh/garlic/centromere.txt

awk '$1=$1" 0 1"' $data/roh/garlic/centromere.txt > $data/roh/garlic/temp && mv -f $data/roh/garlic/temp $data/roh/garlic/centromere.txt
```

## Run GARLIC
```bash
salloc --nodes 1 --ntasks 1 --mem=50G --time=9:00:00 

#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic/hKIWA"
centromere="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic/centromere.txt"


#run 
garlic --auto-winsize --auto-overlap-frac --winsize 100 --tped $work_dir/h.tped --tfam $work_dir/h.tfam --tgls $work_dir/h.tgls --gl-type GQ --resample 40 --centromere $centromere --size-bounds 1000000 2000000 3000000 4000000 5000000 --out $work_dir/hKIWA

#Look at file
grep -v ^track hKIWA.roh.bed | cut -f4 | uniq