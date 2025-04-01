# PCA 


```bash
#Set Variables 
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"

#File Prep
cd $data/pop_structure
tabix -p vcf $data/vcf/$vcf

#Convert VCF to Plink Format
cd $data/pop_structure
plink --vcf $data/$vcf --make-bed --allow-extra-chr --chr-set 30 --out $data/pop_structure/pca

#Run PCA
cd $data/pop_structure
plink --bfile pca --pca --allow-extra-chr --chr-set 30 --out pca_results
```