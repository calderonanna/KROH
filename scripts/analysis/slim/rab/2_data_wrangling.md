# Data Wrangling
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf"

# Reheader Sample Names
bcftools reheader --samples $scripts/hKIWA_IDS_e759877.txt $work/hKIWA_rec.vcf -o $work/hKIWA_rec_reheadered.vcf
bcftools reheader --samples $scripts/cKIWA_IDS.txt $work/cKIWA_rec.vcf -o $work/cKIWA_rec_reheadered.vcf

#Merge VCFs
bgzip $work/hKIWA_rec_reheadered.vcf
bgzip $work/cKIWA_rec_reheadered.vcf
bcftools index $work/hKIWA_rec_reheadered.vcf.gz
bcftools index $work/cKIWA_rec_reheadered.vcf.gz
bcftools merge $work/hKIWA_rec_reheadered.vcf.gz $work/cKIWA_rec_reheadered.vcf.gz -Oz -o $work/rec.vcf.gz
bcftools index $work/rec.vcf.gz
rm -rf *KIWA*
```