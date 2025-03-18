# ROH Calling with PLINK
Following Ceballos et al. 2018 (DOI 10.1186/s12864-018-4489-0)

## File Preperation
Convert vcf to PLINK binary format
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.vcf.gz"

plink --vcf $data/vcf/$vcf --make-bed --allow-extra-chr --chr-set 30 --out $data/roh/plink/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto
```

## Call ROH
```bash
cd $data/roh/plink

plink --bfile KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto --homozyg --homozyg-snp 50 --homozyg-kb 300 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --allow-extra-chr --chr-set 30
```