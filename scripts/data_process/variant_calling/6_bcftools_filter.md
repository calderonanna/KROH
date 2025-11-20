# Bcftools Filter

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

Extract Genotype Read Depth at 95% and 5%
echo "95%" >> $gatk/log/depth_per.txt
for i in {1..13}; do 
    bcftools query -f '[%DP\t]\n' $gatk/KIWA_bi_qual.vcf.gz \
    | cut -f${i} \
    | grep -v '\.' \
    | sort -n \
    | awk '{array[NR] = $0} END {print array[int(NR*0.95 + 0.5)]}' \
    >> $gatk/log/depth_per.txt;
done

echo "5%" >> $gatk/log/depth_per.txt
for i in {1..13}; do 
    bcftools query -f '[%DP\t]\n' $gatk/KIWA_bi_qual.vcf.gz \
    | cut -f${i} \
    | grep -v '\.' \
    | sort -n \
    | awk '{array[NR] = $0} END {print array[int(NR*0.05 + 0.5)]}' \
    >> $gatk/log/depth_per.txt;
done

#Genotype Read Depth
bcftools filter $gatk/KIWA_bi_qual.vcf.gz -e 'FMT/DP<1 || FMT/DP>34' -S . -Oz -o $gatk/KIWA_bi_qual_gtdp.vcf.gz

#Genotype Quality
bcftools filter $gatk/KIWA_bi_qual_gtdp.vcf.gz -e 'FMT/GQ<20' -S . -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq.vcf.gz

#Missing Data
bcftools view -e 'F_MISSING > 0.5' $gatk/KIWA_bi_qual_gtdp_gtgq.vcf.gz -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss.vcf.gz

#Excess Heterozygosity
bcftools view -e 'COUNT(GT="het")>=11' $gatk/vcf/KIWA_bi_qual_gtdp_gtgq_fmiss.vcf.gz -Oz -o $gatk/vcf/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz

#Autosomes
bcftools view $gatk/vcf/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz --regions-file $scripts/autochrs.txt -Oz -o $gatk/vcf/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet_auto.vcf.gz

```

## Filter Samples
```bash
nano $scripts/split_vcf.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=split_vcf
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"

bcftools view -S $scripts/cKIWA_IDS.txt $vcf/KIWA.vcf.gz -Oz -o $vcf/cKIWA.vcf.gz

bcftools view -S $scripts/hKIWA_IDS_e759877.txt $vcf/KIWA.vcf.gz -Oz -o $vcf/hKIWA.vcf.gz
