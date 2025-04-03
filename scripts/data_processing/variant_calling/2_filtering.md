## Filtering
I followed a similar filtering protocol as in Wood et al. 2023 for the Bachman's ROH analysis. 
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/filter_variants_KIWA.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=filter_variants_KIWA
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Add All Tags
bcftools +fill-tags -Oz $work_dir/KIWA.vcf.gz -o $work_dir/KIWA_tags.vcf.gz -- -t all

#Exclude Sample 759877
bcftools view -S $scripts/KIWA_IDS_e759877.txt $work_dir/KIWA_tags.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877.vcf.gz

#Remove chrZ
bcftools view -h $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet.vcf.gz | grep '^##contig=<ID=chr' >> $work_dir/chrs.txt
sed -i 's/##contig=<ID=//g' $work_dir/chrs.txt
sed -i 's/,.*//g' $work_dir/chrs.txt
sed -i '$d' $work_dir/chrs.txt
chr_list=$(cat $work_dir/chrs.txt | tr "\n" "," | sed 's/,$//')
bcftools index $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet.vcf.gz
bcftools view -r $chr_list $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.vcf.gz

#Biallelic Sites
bcftools view -m2 -M2 -v snps $work_dir/KIWA_tags_e759877.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi.vcf.gz

#Quality and Depth
bcftools filter -e 'QUAL<20 || INFO/DP<6' $work_dir/KIWA_tags_e759877_bi.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp.vcf.gz

#Drop AMRE and HOWA samples

#Missing Sites
bcftools view -i 'N_MISSING<2' $work_dir/KIWA_tags_e759877_bi_qual_dp.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss.vcf.gz

#Excess Heterozygosity (>80%)
bcftools view -e 'COUNT(GT="het")>=10' $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet.vcf.gz

#Remove Monomorphic Sites 
bcftools view $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.vcf.gz -c 1:minor -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz
```


