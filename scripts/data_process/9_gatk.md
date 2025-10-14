# GATK4

## Installation
```bash
#Install sdk
curl -s "https://get.sdkman.io" | bash
echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc

#Choose Java Version 17
cd /storage/home/abc6435/.sdkman/candidates/java
sdk list java
sdk install java 17.0.16-tem

echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.16-tem"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#Install GATK4 and add to bashrc
cd /storage/home/abc6435/SzpiechLab/bin
wget https://github.com/broadinstitute/gatk/releases/download/4.6.2.0/gatk-4.6.2.0.zip
unzip gatk-4.6.2.0.zip
rm -rf gatk-4.6.2.0.zip
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/gatk-4.6.2.0:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## HaplotypeCaller
```bash
for i in `cat $scripts/KIWA_IDS_e759877.txt`;do
    cat<<EOT > $scripts/haplotypecaller_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --ntasks=2
#SBATCH --time=100:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=haplotypecaller_${i}.bash
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Index bams
cd \$bam
samtools index \$bam/${i}_sorted_marked.rescaled.bam

#Run HaplotypeCaller
gatk HaplotypeCaller \\
    -R \$ref \\
    -I \$bam/${i}_sorted_marked.rescaled.bam\\
    -ERC GVCF \\
    -O \$gatk/${i}.g.vcf \\
    --native-pair-hmm-threads 2 \\
    >& \$gatk/log/${i}gvcf.log
EOT
done

# Check For Completion
cd $gatk
for file in $(ls); do 
    echo $file
    grep "Caller done" $file
    echo ""; 
done
```

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

#Combine GVCFs
samples=$(ls $gatk/*.g.vcf | sed 's/^/--variant /')
gatk CombineGVCFs \
    $(echo $samples) \
    -O $gatk/KIWA_comb.vcf \
    -R $ref \
    >& $gatk/log/KIWA_gvcfs.log

#Zip and Index
for i in `cat $scripts/KIWA_IDS_e759877.txt`; do 
    nohup bgzip $gatk/${i}.g.vcf; 
done

nohup bgzip $gatk/KIWA_comb.vcf
nohup tabix $gatk/KIWA_comb.vcf.gz

#Genotype
gatk --java-options "-Xmx100g" GenotypeGVCFs \
    -R $ref \
    -V $gatk/KIWA_comb.vcf.gz -O $gatk/KIWA.vcf.gz
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

# #Count Sites
# echo "KIWA.vcf.gz" >> $gatk/log/snps.log
# zgrep -v ^## $gatk/KIWA.vcf.gz | wc -l >> $gatk/log/snps.log
# echo "" >> $gatk/log/snps.log

# #Biallelic Sites
# bcftools view -m2 -M2 -v snps $gatk/KIWA.vcf.gz -Oz -o $gatk/KIWA_bi.vcf.gz
# echo "KIWA_bi.vcf.gz" >> $gatk/log/snps.log
# zgrep -v ^## $gatk/KIWA_bi.vcf.gz | wc -l >> $gatk/log/snps.log
echo "" >> $gatk/log/snps.log

#Site Quality
bcftools view -i 'QUAL>=50' $gatk/KIWA_bi.vcf.gz -Oz -o $gatk/KIWA_bi_qual.vcf.gz
echo "KIWA_bi_qual.vcf.gz" >> $gatk/log/snps.log
zgrep -v ^## $gatk/KIWA_bi_qual.vcf.gz | wc -l >> $gatk/log/snps.log
echo "" >> $gatk/log/snps.log
```
## Filter Genotypes
```bash
nano $scripts/filter_genotypes.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_genotypes
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"

#Extract Genotype Read Depth at 95% and 5%
# echo "95%" >> $gatk/log/depth_per.txt
# for i in {1..13}; do 
#     bcftools query -f '[%DP\t]\n' $gatk/KIWA_bi_qual.vcf.gz \
#     | cut -f${i} \
#     | grep -v '\.' \
#     | sort -n \
#     | awk '{array[NR] = $0} END {print array[int(NR*0.95 + 0.5)]}' \
#     >> $gatk/log/depth_per.txt;
# done

# echo "5%" >> $gatk/log/depth_per.txt
# for i in {1..13}; do 
#     bcftools query -f '[%DP\t]\n' $gatk/KIWA_bi_qual.vcf.gz \
#     | cut -f${i} \
#     | grep -v '\.' \
#     | sort -n \
#     | awk '{array[NR] = $0} END {print array[int(NR*0.05 + 0.5)]}' \
#     >> $gatk/log/depth_per.txt;
# done

#Genotype Read Depth
bcftools filter $gatk/KIWA_bi_qual.vcf.gz -e 'FMT/DP<1' || 'FMT/DP>34' -S . -Oz -o $gatk/KIWA_bi_qual_gtdp.vcf.gz

#Genotype Quality
bcftools filter $gatk/KIWA_bi_qual_gtdp.vcf.gz -e 'FMT/GQ<20' -S . -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq.vcf.gz

#Missing Data
bcftools view -e 'F_MISSING > 0.5' $gatk/KIWA_bi_qual_gtdp_gtgq.vcf.gz -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss.vcf.gz

#Excess Heterozygosity
bcftools view -e 'COUNT(GT="het")>=11' $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss.vcf.gz -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz

#Autosomes
bcftools view $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz --regions-file $scripts/autochrs.txt -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz