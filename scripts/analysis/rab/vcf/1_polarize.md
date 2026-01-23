# Polarize
`get_only_private_alt.py $vcf $pop_file`
- The population file is a list of sample ids (one per line) for the population you want to get the private alternate alleles. 

## Run
```bash
bin="/storage/group/zps5164/default/bin"
vcf="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf/dSETO_auto_bi_qual_dp_gq.vcf.gz"
work="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

$bin/get_only_private_alt.py $vcf $scripts/KIWA_IDS_e759877.txt > $work/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf
bgzip $work/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf
bcftools index $work/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf.gz
```