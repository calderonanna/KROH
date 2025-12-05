## Filter 
```bash
nano $scripts/filter.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=10:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
chrs=$(paste -sd, $scripts/autochrs.txt)

#Autosomes
bcftools view $gatk/vcf/dSETO.vcf.gz -r "$chrs" -Oz -o $gatk/vcf/dSETO_auto.vcf.gz

#Biallelic Sites
bcftools view -m2 -M2 -v snps $gatk/vcf/dSETO_auto.vcf.gz -Oz -o $gatk/vcf/dSETO_auto_bi.vcf.gz

#Site Quality
bcftools view -i 'QUAL>=50' $gatk/vcf/dSETO_auto_bi.vcf.gz -Oz -o $gatk/vcf/dSETO_auto_bi_qual.vcf.gz

#Genotype Read Depth
bcftools filter $gatk/vcf/dSETO_auto_bi_qual.vcf.gz -e 'FMT/DP<1 || FMT/DP>27' -S . -Oz -o $gatk/vcf/dSETO_auto_bi_qual_dp.vcf.gz

#Genotype Quality
bcftools filter $gatk/vcf/dSETO_auto_bi_qual_dp.vcf.gz -e 'FMT/GQ<20' -S . -Oz -o $gatk/vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz
```

```bash
#Extract Genotype Read Depth at 95% and 5%
# echo "95%" >> $gatk/log/5_95_depth.txt
# for i in {1..25}; do 
#     bcftools query -f '[%DP\t]\n' $gatk/vcf/dSETO_bi_qual.vcf.gz \
#     | cut -f${i} \
#     | grep -v '\.' \
#     | sort -n \
#     | awk '{array[NR] = $0} END {print array[int(NR*0.95 + 0.5)]}' \
#     >> $gatk/log/5_95_depth.txt;
# done

# echo "5%" >> $gatk/log/5_95_depth.txt
# for i in {1..25}; do 
#     bcftools query -f '[%DP\t]\n' $gatk/vcf/dSETO_bi_qual.vcf.gz \
#     | cut -f${i} \
#     | grep -v '\.' \
#     | sort -n \
#     | awk '{array[NR] = $0} END {print array[int(NR*0.05 + 0.5)]}' \
#     >> $gatk/log/5_95_depth.txt;
# done
```