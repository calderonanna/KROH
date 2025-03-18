## Filtering
I followed a similar filtering protocol as in Wood et al. 2023 for the Bachman's ROH analysis. 
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=9:00:00 

work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Biallelic Sites
bcftools view -m2 -M2 -v snps $work_dir/KIWA.vcf.gz -Oz -o $work_dir/KIWA_bi.vcf.gz

#Quality and Depth
bcftools filter -e 'QUAL<20 || INFO/DP<6' $work_dir/KIWA_bi.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp.vcf.gz

#Missing Sites
bcftools view -i 'N_MISSING<3' $work_dir/KIWA_bi_qual_dp.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss.vcf.gz

#Excess Heterozygosity (>80%)
bcftools view -e 'COUNT(GT="het")>=11' $work_dir/KIWA_bi_qual_dp_nmiss.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss_exhet.vcf.gz

#Add All Tags
bcftools +fill-tags -Oz $work_dir/KIWA_bi_qual_dp_nmiss_exhet.vcf.gz -o $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags.vcf.gz -- -t all

#HWE
bcftools view -i 'INFO/HWE>0.001' $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE.vcf.gz

#Remove chrZ
bcftools view -h $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE.vcf.gz | grep '^##contig=<ID=chr' >> chrs.txt
sed -i 's/##contig=<ID=//g' chrs.txt
sed -i 's/,.*//g' chrs.txt
sed -i '$d' chrs.txt
chr_list=$(cat chrs.txt | tr "\n" "," | sed 's/,$//')

bcftools index $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE.vcf.gz
bcftools view -r $chr_list $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.vcf.gz

#Add GQ
bcftools +fill-tags -Oz KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto.vcf.gz -o KIWA_bi_qual_dp_nmiss_exhet_tags_HWE_auto_GQ.vcf.gz -- -t GQ


