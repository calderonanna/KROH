# Data Wrangling

```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
h_coef="h00 h05 h10"


for h in $h_coef; do
    cd $work/${h}

    #Sample Names
    echo -e "i0_1929_eggs\ni1_1929_eggs\ni2_1929_eggs\ni3_1929_eggs\ni4_1929_eggs\ni5_1929_eggs\ni6_1929_eggs" > 1929IDS.txt
    echo -e "i0_2009_eggs\ni1_2009_eggs\ni2_2009_eggs\ni3_2009_eggs\ni4_2009_eggs\ni5_2009_eggs\ni6_2009_eggs" > 2009IDS.txt

    #Unzip VCF
    gunzip ${h}_1929_eggs.vcf.gz
    gunzip ${h}_2009_eggs.vcf.gz

    bcftools reheader --samples 1929IDS.txt ${h}_1929_eggs.vcf -o ${h}_1929_eggs_reheadered.vcf
    bcftools reheader --samples 2009IDS.txt ${h}_2009_eggs.vcf -o ${h}_2009_eggs_reheadered.vcf

    #Zip and Index
    bgzip ${h}_1929_eggs_reheadered.vcf
    bgzip ${h}_2009_eggs_reheadered.vcf
    bcftools index ${h}_1929_eggs_reheadered.vcf.gz
    bcftools index ${h}_2009_eggs_reheadered.vcf.gz

    # Merge VCFs and Filter
    bcftools merge ${h}_1929_eggs_reheadered.vcf.gz ${h}_2009_eggs_reheadered.vcf.gz -Oz -o ${h}_eggs.vcf.gz
    bcftools view -i 'F_MISSING == 0' ${h}_eggs.vcf.gz -Oz -o ${h}_eggs_fmiss.vcf.gz

    #File Clean Up
    rm -rf *IDS* *rehead* *csi* *.vcf ${h}.vcf.gz;
done
```