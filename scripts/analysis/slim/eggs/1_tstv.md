# Transition (TS) and Transversions (TV)
To calculate the probability the site is a transition (prob1) use ts/(ts+tv)

```bash
#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf" 
bcftools stats $vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz | grep TSTV
bcftools stats $vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz | grep TSTV

awk -v cKIWA_ts=48789171 -v cKIWA_tv=23538294 'BEGIN {print cKIWA_ts / (cKIWA_ts + cKIWA_tv)}'

awk -v hKIWA_ts=48789171 -v hKIWA_tv=23538294 'BEGIN {print hKIWA_ts / (hKIWA_ts + hKIWA_tv)}'
```