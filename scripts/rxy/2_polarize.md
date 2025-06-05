# Polarize

```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/filter_polarize_vcf.bash
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
bin="/storage/home/abc6435/SzpiechLab/bin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#filter out any missing sites
bcftools view -i 'N_MISSING<1' \
    $vcf_dir/chKIWA/chKIWA_AMRE_HOWA_tags_auto_bi_e759877.vcf.gz \
    -Oz -o $vcf_dir/chKIWA/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz

#Extract Genotypes
bcftools annotate -x INFO,FORMAT \
    $vcf_dir/chKIWA/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz \
    -Oz -o $vcf_dir/chKIWA/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss_gt.vcf.gz

#Obtain private alleles
$bin/get_only_private_alt.py \
    $vcf_dir/chKIWA/chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss_gt.vcf.gz \
    $scripts/KIWA_IDS_e759877.txt >> $vcf_dir/priv/KIWA_private.vcf

bgzip $vcf_dir/priv/KIWA_private.vcf

#Create .bed file
bcftools query -f '%CHROM\t%POS' $vcf_dir/priv/KIWA_private.vcf.gz > $vcf_dir/priv/KIWA_private.bed

#Format .bed
awk '{print $1, $2-1, $2}' OFS="\t" $vcf_dir/priv/KIWA_private.bed \
    > $vcf_dir/priv/temp && mv -f $vcf_dir/priv/temp $vcf_dir/priv/KIWA_private.bed

