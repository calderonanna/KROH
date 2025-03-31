# ROH Calling with PLINK
Following Ceballos et al. 2018 (DOI 10.1186/s12864-018-4489-0)

## File Preperation
Convert vcf to PLINK binary format
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"

plink --vcf $data/vcf/$vcf --make-bed --allow-extra-chr --chr-set 30 --out $data/roh/plink/KIWA
```

## Call ROH
```bash
cd $data/roh/plink

#Low Heterozygosity Allowance
plink --bfile KIWA --homozyg --homozyg-snp 50 --homozyg-kb 300 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --allow-extra-chr --chr-set 30

mkdir $data/roh/plink/het_1
mv *plink* $data/roh/plink/het_1


#High Heterozygosity Allowance
plink --bfile KIWA --homozyg --homozyg-snp 50 --homozyg-kb 300 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --allow-extra-chr --chr-set 30

mkdir $data/roh/plink/het_3
mv *plink* $data/roh/plink/het_3
```
## Clean Up Files
```bash
cd $data/roh/plink/het_1
cat plink.hom.indiv | tr -s ' ' > plink_het1_ind.txt 
cat plink.hom | tr -s ' ' > plink_het1.txt
rm -rf plink.hom.indiv
rm -rf plink.hom

cd $data/roh/plink/het_3
cat plink.hom.indiv | tr -s ' ' > plink_het3_ind.txt 
cat plink.hom | tr -s ' ' > plink_het3.txt
rm -rf plink.hom.indiv
rm -rf plink.hom
```


## Historical Samples
```bash
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.h"

#Filter for 2:minor
bcftools view $vcf.vcf.gz -c 2:minor -Oz -o $vcf.maf2.vcf.gz

plink --vcf $vcf.maf2.vcf.gz --make-bed --allow-extra-chr --chr-set 30 --out $data/roh/plink/hist_maf2/hKIWA

plink --bfile hKIWA --homozyg --homozyg-snp 50 --homozyg-kb 300 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --allow-extra-chr --chr-set 30
