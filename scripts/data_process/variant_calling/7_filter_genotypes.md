# Filter Genotypes
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
chrs=$(paste -sd, $scripts/autochrs.txt)

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

#Autosomes
bcftools view $gatk/vcf/dSETO_bi_qual.vcf.gz -r "$chrs" -o -Oz $gatk/vcf/dSETO_bi_qual_auto.vcf.gz

#Genotype Read Depth
bcftools filter $gatk/vcf/dSETO_bi_qual_auto.vcf.gz -e 'FMT/DP<1 || FMT/DP>27' -S . -Oz -o $gatk/vcf/dSETO_bi_qual_auto_gtdp.vcf.gz

#Genotype Quality
bcftools filter $gatk/vcf/dSETO_bi_qual_auto_gtdp.vcf.gz -e 'FMT/GQ<20' -S . -Oz -o $gatk/vcf/dSETO_bi_qual_auto_gtdp_gtql.vcf.gz
```

#Missing
bcftools view -e 'N_MISSING > 10' $gatk/vcf/dSETO_bi_qual_auto_gtdp_gtql.vcf.gz -Oz -o $gatk/vcf/dSETO_bi_qual_auto_gtdp_gtql_nmiss.vcf.gz

#Excess Heterozygosity
bcftools view -e 'COUNT(GT="het")>=11' $gatk/vcf/dSETO_bi_qual_gtdp_gtgq_fmiss.vcf.gz -Oz -o $gatk/vcf/dSETO_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz

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

bcftools view -S $scripts/cdSETO_IDS.txt $vcf/dSETO.vcf.gz -Oz -o $vcf/cdSETO.vcf.gz

bcftools view -S $scripts/hdSETO_IDS_e759877.txt $vcf/dSETO.vcf.gz -Oz -o $vcf/hdSETO.vcf.gz
