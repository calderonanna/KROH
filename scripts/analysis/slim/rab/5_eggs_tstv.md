# Transition (TS) and Transversions (TV)
To calculate the probability the site is a transition (prob1) use ts/(ts+tv)

```bash
#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf" 
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Split VCF by Sample
bcftools view -S \
$scripts/cKIWA_IDS.txt \
$vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf \
-o $vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_cKIWA.vcf

bcftools view -S \
$scripts/hKIWA_IDS_e759877.txt \
$vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf \
-o $vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_hKIWA.vcf


bcftools stats $vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_cKIWA.vcf \
| grep TSTV

bcftools stats $vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_hKIWA.vcf \
| grep TSTV


awk -v cKIWA_ts=5878123 -v cKIWA_tv=2372314 'BEGIN {print cKIWA_ts / (cKIWA_ts + cKIWA_tv)}'
awk -v hKIWA_ts=5878123 -v hKIWA_tv=2372314 'BEGIN {print hKIWA_ts / (hKIWA_ts + hKIWA_tv)}'

#0.712462
```