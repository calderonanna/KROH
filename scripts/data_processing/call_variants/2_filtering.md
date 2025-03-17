## Filtering
I followed a similar filtering protocol as in Wood et al. 2023 for the Bachman's ROH analysis. 
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=6:00:00 

work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Biallelic Sites
bcftools view -m2 -M2 -v snps $work_dir/KIWA.vcf.gz -Oz -o $work_dir/KIWA_bi.vcf.gz

#Quality and Depth
bcftools filter -e 'QUAL<20 || INFO/DP<6' $work_dir/KIWA_bi.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp.vcf.gz

#Missing Sites
bcftools view -i 'N_MISSING<7' $work_dir/KIWA_bi_qual_dp.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss.vcf.gz

#Excess Heterozygosity (>80%)
bcftools view -e 'COUNT(GT="het")>=11' $work_dir/KIWA_bi_qual_dp_nmiss.vcf.gz -Oz -o $work_dir/KIWA_bi_qual_dp_nmiss_exhet.vcf.gz