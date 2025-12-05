# Filter Divstats
```bash
nano $scripts/filter_divstats.bash
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


#Filter Pops
bcftools view -S $scripts/hKIWA_IDS_e759877.txt $vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz -Oz -o $vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz

bcftools view -S $scripts/cKIWA_IDS.txt $vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz -Oz -o $vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz

#Index 
nohup tabix $vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz
nohup tabix $vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz
```