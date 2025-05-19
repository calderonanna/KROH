## Filtering

```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/filter_variants.bash
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
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Add All Tags
bcftools +fill-tags \
    $work/KIWA.vcf.gz \
    -Oz -o $work/KIWA_tags.vcf.gz \
    -- -t all

#Index
bcftools index \
    $work/KIWA_tags.vcf.gz

#Include only autosomes
chr_list=$(cat $scripts/chrs.txt | tr "\n" "," | sed 's/,$//')
bcftools view \
    -r $chr_list \
    $work/KIWA_tags.vcf.gz \
    -Oz -o $work/KIWA_tags_auto.vcf.gz

#Sites: Biallelic 
bcftools view \
    -m2 -M2 -v snps \
    $work/KIWA_tags_auto.vcf.gz \
    -Oz -o $work/KIWA_tags_auto_bi.vcf.gz
```
