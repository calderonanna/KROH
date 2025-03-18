# ROH Calling with GARLIC

## Create .tfam and .tped
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.vcf.gz"

plink --vcf $data/vcf/$vcf --recode transpose --double-id --chr-set 30 --allow-extra-chr --out $data/roh/garlic/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto

awk '$1="kirtlandii"' KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.tfam > temp && mv -f temp KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.tfam
```

## Create .tgls
```bash
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.vcf.gz"
shared="/storage/home/abc6435/SzpiechLab/shared"

$shared/create_tgls_from_vcf.py $data/vcf/$vcf > $data/roh/garlic/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.tgls