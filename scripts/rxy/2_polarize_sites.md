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
```