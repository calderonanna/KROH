# Data Wrangling

```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
h_coef="h00 h05 h10"
#Index Files and Merge

for h in $h_coef; do

    for i in {1..100}; do
        gunzip $work/${h}_1929_eggs_R${i}.vcf.gz
        gunzip $work/${h}_2009_eggs_R${i}.vcf.gz
        bgzip $work/${h}_1929_eggs_R${i}.vcf
        bgzip $work/${h}_2009_eggs_R${i}.vcf
        bcftools index $work/${h}_1929_eggs_R${i}.vcf.gz
        bcftools index $work/${h}_2009_eggs_R${i}.vcf.gz

        # Merge VCFs
        bcftools merge $work/${h}_1929_eggs_R${i}.vcf.gz $work/${h}_2009_eggs_R${i}.vcf.gz -Oz -o $work/${h}_R${i}_eggs.vcf.gz
    done

done
```