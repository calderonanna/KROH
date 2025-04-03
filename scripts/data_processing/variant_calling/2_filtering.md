## Filtering

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/filter_variants.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=filter_variants_KIWA
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Add All Tags
bcftools +fill-tags $vcf_dir/chKIWA_AMRE_HOWA.vcf.gz -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz -- -t all

#Include only autosomes
bcftools view -h $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz | grep '^##contig=<ID=chr' >> $vcf_dir/chrs.txt
sed -i 's/##contig=<ID=//g' $vcf_dir/chrs.txt
sed -i 's/,.*//g' $vcf_dir/chrs.txt
sed -i '$d' $vcf_dir/chrs.txt
chr_list=$(cat $vcf_dir/chrs.txt | tr "\n" "," | sed 's/,$//')

bcftools index $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz

bcftools view -r $chr_list $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz

#Biallelic Sites
bcftools view -m2 -M2 -v snps $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz

#Quality and Depth
bcftools filter -e 'QUAL<20 || INFO/DP<6' $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_qual_dp.vcf.gz
```


