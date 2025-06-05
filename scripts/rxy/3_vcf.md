# VCF

```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/subset_private_alleles.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=3:00:00
#SBATCH --account=open
#SBATCH --job-name=subset_private_alleles
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
rxy_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

bcftools view -T $vcf_dir/priv/KIWA_private.bed \
    $vcf_dir/KIWA_tags_auto_bi.vcf.gz \
    -Oz -o $rxy_dir/KIWA_tags_auto_bi_private.vcf.gz

bcftools view -i 'N_MISSING<1' \
    $rxy_dir/KIWA_tags_auto_bi_private.vcf.gz \
    -Oz -o $rxy_dir/KIWA_tags_auto_bi_private_nmiss.vcf.gz

bcftools view -T $vcf_dir/priv/KIWA_private.bed \
    $vcf_dir/KIWA_tags_auto_bi.vcf.gz \
    -Oz -o $rxy_dir/KIWA_dowsampled_tags_auto_bi_private.vcf.gz

bcftools view -i 'N_MISSING<1' \
    $rxy_dir/KIWA_dowsampled_tags_auto_bi_private.vcf.gz \
    -Oz -o $rxy_dir/KIWA_dowsampled_tags_auto_bi_private_nmiss.vcf.gz 
```