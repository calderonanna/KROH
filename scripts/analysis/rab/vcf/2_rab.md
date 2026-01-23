# Rab

## Test File
```bash
bin="/storage/group/zps5164/default/bin"
vcf="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz"
work="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

bcftools view -r chr29 $work/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf.gz -o $work/rab_chr29_test.vcf

rsync abc6435@submit.hpc.psu.edu:/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf/rab_chr29_test.vcf ~/Desktop/RABvcfs
rsync abc6435@submit.hpc.psu.edu:/storage/group/zps5164/default/abc6435/KROH/data/rab/tv/intergenic.txt ~/Desktop/RABvcfs 
rsync abc6435@submit.hpc.psu.edu:/storage/group/zps5164/default/abc6435/KROH/data/rab/tv/tolerated.txt ~/Desktop/RABvcfs 
rsync abc6435@submit.hpc.psu.edu:/storage/group/zps5164/default/abc6435/KROH/scripts/KIWA_IDS_e759877.txt ~/Desktop/RABvcfs 