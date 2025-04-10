## Filtering Sites

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
#SBATCH --job-name=filter_variants_KIWA
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Add All Tags
bcftools +fill-tags \
    $vcf_dir/chKIWA_AMRE_HOWA.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
    -- -t all

#Include only autosomes
bcftools view -h \
    $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
    | grep '^##contig=<ID=chr' \
    >> $vcf_dir/chrs.txt
sed -i 's/##contig=<ID=//g' $vcf_dir/chrs.txt
sed -i 's/,.*//g' $vcf_dir/chrs.txt
sed -i '$d' $vcf_dir/chrs.txt
chr_list=$(cat $vcf_dir/chrs.txt | tr "\n" "," | sed 's/,$//')

bcftools index \
    $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz

bcftools view \
    -r $chr_list \
    $vcf_dir/chKIWA_AMRE_HOWA_tags.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz

#Biallelic Sites
bcftools view \
    -m2 -M2 -v snps \
    $vcf_dir/chKIWA_AMRE_HOWA_tags_auto.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz

#Quality
bcftools filter \
    -e 'QUAL<50' \
    $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz \
    -Oz -o $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_qual.vcf.gz

###Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Exclude AMRE, HOWA, and hKIWA-759877
bcftools view \
    -S $scripts/KIWA_IDS_e759877.txt \
    $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_qual.vcf.gz \
    -Oz -o $work_dir/chKIWA_tags_auto_bi_qual.vcf.gz

#Genotype Read Depth
bcftools filter \
    -e 'FORMAT/DP < 7' \
    --set-GTs . \
    $work_dir/chKIWA_tags_auto_bi_qual.vcf.gz \
    -Oz -o $work_dir/chKIWA_tags_auto_bi_qual_gtdp.vcf.gz

# Missing
bcftools view -e \
    'N_MISSING>3' \
    $work_dir/chKIWA_tags_auto_bi_qual_gtdp.vcf.gz \
    -Oz -o $work_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss.vcf.gz

#Excess Heterozygosity (75%)
bcftools view -e \
    'COUNT(GT="het")>=10' \
    $work_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss.vcf.gz \
    -Oz -o $work_dir/chKIWA_tags_auto_bi_qual_gtdp_nmiss_exhet.vcf.gz
```


