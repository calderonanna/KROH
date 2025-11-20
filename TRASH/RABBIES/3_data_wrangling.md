# Data Wrangling

## Upload VCFs
```bash 
h_coef="h00 h05 h10"
for h in $h_coef; do
    scp /Users/abc6435/Desktop/KROH/data/slim/rxy/${h}/${h}_*.vcf abc6435@submit.hpc.psu.edu://storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/${h}
done

```
## Data Wrangling
```bash
h_coef="h00 h05 h10"
for h in $h_coef; do
    #Set Variables
    work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
    cd $work/${h}

    # Reheader Sample Names
    echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929\ni6_1929" > 1929IDS.txt
    echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt

    bcftools reheader --samples 1929IDS.txt ${h}_1929.vcf -o ${h}_1929_reheadered.vcf
    bcftools reheader --samples 2009IDS.txt ${h}_2009.vcf -o ${h}_2009_reheadered.vcf

    #Zip and Index
    bgzip ${h}_1929_reheadered.vcf
    bgzip ${h}_2009_reheadered.vcf
    bcftools index ${h}_1929_reheadered.vcf.gz
    bcftools index ${h}_2009_reheadered.vcf.gz

    # Merge VCFs and Filter
    bcftools merge ${h}_1929_reheadered.vcf.gz ${h}_2009_reheadered.vcf.gz -Oz -o ${h}.vcf.gz
    bcftools view -i 'F_MISSING == 0' ${h}.vcf.gz -Oz -o ${h}_fmiss.vcf.gz

    #Obtain selection coefficients
    bcftools query -f '%INFO/S' ${h}_fmiss.vcf.gz > ${h}_s.txt
    
    #File Clean Up
    rm -rf *IDS* *rehead* *csi* *.vcf ${h}.vcf.gz;
done
```