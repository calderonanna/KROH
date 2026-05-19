# PCA
https://speciationgenomics.github.io/pca/

## Extract KIWA Samples
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

bcftools view -S $scripts/KIWA_IDS_e759877.txt $work/dSETO_auto_bi_qual_dp_gq.vcf.gz -Oz -o $work/dSETO_auto_bi_qual_dp_gq_KIWA.vcf.gz
```

## Linkage Pruning
```bash
salloc --nodes=1 --time=5:00:00 --mem=10GB --account=open --partition=standard

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf/dSETO_auto_bi_qual_dp_gq_KIWA.vcf.gz"

plink --vcf $vcf --double-id --allow-extra-chr --chr-set 30 --set-missing-var-ids @:# --indep-pairwise 50 10 0.1 --out $data/pca/KIWA
```

## PCA
```bash
plink --vcf $vcf --double-id --allow-extra-chr --chr-set 30 --set-missing-var-ids @:# --extract $data/pca/KIWA.prune.in --make-bed --pca --out $data/pca/KIWA

