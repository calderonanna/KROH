#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=filter_divstats
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
vcf="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf"
bin="/storage/group/zps5164/default/bin"

# #Polarize
# $bin/get_only_private_alt.py \
#     $vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz \
#     $scripts/KIWA_IDS_e759877.txt \
#     > $vcf/dSETO_auto_bi_qual_dp_gq_KIWA_polarized.vcf

#Zip
bgzip $vcf/dSETO_auto_bi_qual_dp_gq_KIWA_polarized.vcf

#Missing
bcftools view -i 'F_MISSING=0' $vcf/dSETO_auto_bi_qual_dp_gq_KIWA_polarized.vcf.gz -Oz -o $vcf/dSETO_auto_bi_qual_dp_gq_KIWA_polarized_fmiss.vcf.gz
```
## Filter Samples
#Excess Heterozygosity
bcftools view -e 'COUNT(GT="het")>=11' $gatk/vcf/dSETO_bi_qual_gtdp_gtgq_fmiss.vcf.gz -Oz -o $gatk/vcf/dSETO_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz
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
