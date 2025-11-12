## Combine and Genotype
```bash
nano $scripts/combine_genotype_gvcfs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --ntasks=4
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=combine_genotype_gvcfs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
samples=$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf/*.g.vcf | sed 's/^/--variant /')

#Combine GVCFs
gatk CombineGVCFs \
    $samples \
    -O $gatk/gvcf/KIWA_comb.vcf \
    -R $ref \
    >& $gatk/log/KIWA_gvcfs.log

#Zip and Index
for i in `cat $scripts/KIWA_IDS_e759877.txt`; do 
    nohup bgzip $gatk/gvcf/${i}.g.vcf; 
done

nohup bgzip $gatk/gvcf/KIWA_comb.vcf
nohup tabix $gatk/gvcf/KIWA_comb.vcf.gz

#Genotype
gatk --java-options "-Xmx100g" GenotypeGVCFs \
    -R $ref \
    -V $gatk/gvcf/KIWA_comb.vcf.gz -O $gatk/vcf/KIWA.vcf.gz
```

## Filter Sites
```bash
nano $scripts/filter_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=2:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"

#Count Sites
echo "KIWA.vcf.gz" >> $gatk/log/snps.log
zgrep -v ^## $gatk/KIWA.vcf.gz | wc -l >> $gatk/log/snps.log
echo "" >> $gatk/log/snps.log

#Biallelic Sites
bcftools view -m2 -M2 -v snps $gatk/KIWA.vcf.gz -Oz -o $gatk/KIWA_bi.vcf.gz
echo "KIWA_bi.vcf.gz" >> $gatk/log/snps.log
zgrep -v ^## $gatk/KIWA_bi.vcf.gz | wc -l >> $gatk/log/snps.log
echo "" >> $gatk/log/snps.log

#Site Quality
bcftools view -i 'QUAL>=50' $gatk/KIWA_bi.vcf.gz -Oz -o $gatk/KIWA_bi_qual.vcf.gz
echo "KIWA_bi_qual.vcf.gz" >> $gatk/log/snps.log
zgrep -v ^## $gatk/KIWA_bi_qual.vcf.gz | wc -l >> $gatk/log/snps.log
echo "" >> $gatk/log/snps.log
```