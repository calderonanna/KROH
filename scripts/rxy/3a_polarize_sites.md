# Polarize Sites

## Obtain Private Alleles
```bash
nano $scripts/filter_polarize_vcf_rxy.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=12:00:00
#SBATCH --account=dut374_c
#SBATCH --job-name=filter_polarize_vcf_rxy
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf" 
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
bin="/storage/home/abc6435/SzpiechLab/bin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#filter out any missing sites
bcftools view -i 'N_MISSING<1' \
    $vcf_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877.vcf.gz \
    -Oz -o $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz

#Extract Genotypes
bcftools annotate -x INFO,FORMAT \
    $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz \
    -Oz -o $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss_gt.vcf.gz

#Obtain private alleles
cd $work_dir
$bin/get_only_private_alt.py \
    $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss_gt.vcf.gz \
    $scripts/KIWA_IDS_e759877.txt >> $work_dir/KIWA_private.vcf

#Zip 
cd $work_dir
bgzip $work_dir/KIWA_private.vcf

#Convert to bed 
bcftools query -f '%CHROM\t%POS' \
    $work_dir/KIWA_private.vcf.gz >> $work_dir/KIWA_private.bed

#Format bed 
awk '{print $1, $2-1, $2}' OFS="\t" $work_dir/KIWA_private.bed \
    > $work_dir/temp && mv -f $work_dir/temp $work_dir/KIWA_private.bed

#Extract private sites
bcftools view -T $work_dir/KIWA_private.bed \
    $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz \
    -Oz -o $work_dir/HOWA_AMRE_KIWAprivate.gz
```


## Filter VCF
```bash
nano $scripts/filter_vcf_rxy.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=12:00:00
#SBATCH --account=dut374_c
#SBATCH --job-name=filter_vcf_rxy
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
bin="/storage/home/abc6435/SzpiechLab/bin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Only include KIWA samples
bcftools view \
    -S $scripts/KIWA_IDS_e759877.txt \
    $work_dir/HOWA_AMRE_KIWAprivate.gz \
    -Oz -o $work_dir/chKIWA_private.gz

#Genotype: Read Depth and Genotype Quality
bcftools filter \
    -e 'FORMAT/DP < 3 || FORMAT/GQ < 15' \
    --set-GTs . \
    $work_dir/chKIWA_private.gz \
    -Oz -o $work_dir/chKIWA_private_gtdp_gtgq.gz

#Genotype: Missing
bcftools view -i \
    'N_MISSING==0' \
    $work_dir/chKIWA_private_gtdp_gtgq.gz \
    -Oz -o $work_dir/chKIWA_private_gtdp_gtgq_nmiss.gz

#Genotype: Excess Heterozygosity (75%)
bcftools view -e \
    'COUNT(GT="het")>=10' \
    $work_dir/chKIWA_private_gtdp_gtgq_nmiss.gz \
    -Oz -o $work_dir/chKIWA_private_gtdp_gtgq_nmiss_exhet.gz