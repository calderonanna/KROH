# ROH Calling with PLINK
Following Ceballos et al. 2018 (DOI 10.1186/s12864-018-4489-0)

## File Preperation
Convert vcf to PLINK binary format
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf_h="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.h.vcf.gz"
vcf_c="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.c.vcf.gz"

plink --vcf $data/vcf/$vcf_h --make-bed --allow-extra-chr --chr-set 30 --out $data/roh/plink/hKIWA/h

plink --vcf $data/vcf/$vcf_c --make-bed --allow-extra-chr --chr-set 30 --out $data/roh/plink/cKIWA/c
```

## Call ROH
```bash
cd $data/roh/plink/cKIWA

plink --bfile c --homozyg --homozyg-snp 50 --homozyg-kb 300 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --allow-extra-chr --chr-set 30
```