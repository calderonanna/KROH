## Filtering

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/filter_variants.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=08:00:00
#SBATCH --account=open
#SBATCH --job-name=filter_variants
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

# #Add All Tags
# bcftools +fill-tags \
#     $vcf_dir/chKIWA_AMRE_HOWA.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
#     -- -t all

# #Include only autosomes
# bcftools view -h \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
#     | grep '^##contig=<ID=chr' \
#     >> $vcf_dir/chrs.txt
# sed -i 's/##contig=<ID=//g' $vcf_dir/chrs.txt
# sed -i 's/,.*//g' $vcf_dir/chrs.txt
# sed -i '$d' $vcf_dir/chrs.txt
# chr_list=$(cat $vcf_dir/chrs.txt | tr "\n" "," | sed 's/,$//')

# bcftools index \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz

# bcftools view \
#     -r $chr_list \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz

# #Sites: Biallelic 
# bcftools view \
#     -m2 -M2 -v snps \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz

# #Site:Quality
# bcftools filter \
#     -e 'QUAL<50' \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_qual.vcf.gz

# #Samples: Exclude AMRE, HOWA, and hKIWA-759877
# bcftools view \
#     -S $scripts/KIWA_IDS_e759877.txt \
#     $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_qual.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual.vcf.gz

#Genotype: Read Depth and Quality
# bcftools filter \
#     -e 'FORMAT/DP < 6 || FORMAT/GQ < 20' \
#     --set-GTs . \
#     $vcf_dir/chKIWA_tags_auto_bi_qual.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_gtgq.vcf.gz

#Genotype: Missing
bcftools view -e \
    'N_MISSING>4' \
    $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_gtgq.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_gtgq_nmiss.vcf.gz

#Genotype: Excess Heterozygosity (75%)
bcftools view -e \
    'COUNT(GT="het")>=10' \
    $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_gtgq_nmiss.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_gtgq_nmiss_exhet.vcf.gz

# #Genotype: Allele Balance
# bcftools filter -e \
#     'GT="0/1" && (AD[*:1] / (AD[*:0]+AD[*:1]) < 0.3 || AD[*:1] / (AD[*:0]+AD[*:1]) > 0.7)' \
#     --set-GT . \
#     $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet_ab.vcf.gz

# #Genotype: Missing
# bcftools view -e \
#     'N_MISSING>4' \
#     $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet_ab.vcf.gz \
#     -Oz -o $vcf_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet_ab_nmiss.vcf.gz
```


