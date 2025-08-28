# PCA 
```bash
#Set Variables 
vcf="chKIWA_tags_auto_bi_rd_gq_nmiss_exhet.vcf.gz"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure"

cp /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic/$vcf $work_dir

#File Prep
cd $work_dir
tabix -p vcf $vcf

#Convert VCF to Plink Format
plink --vcf $vcf --make-bed --allow-extra-chr --chr-set 30 --out pca

#Run PCA
plink --bfile pca --pca --allow-extra-chr --chr-set 30 --out pca_results
```