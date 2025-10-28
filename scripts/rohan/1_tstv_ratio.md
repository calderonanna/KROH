
## Obtain Ts/Tv Ratio
Comparing Ref to Alt, obtain the number of transitions from purines A↔G and prymidines C↔T. Then obtain the number of transerversions from purines to prymidines (A↔C, A↔T, G↔C, G↔T). Takes the ratio of Transitions (Ts) and Transversions. This will then be used in rohan to improve the accuracy of ROH inference. 

```bash
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf/KIWA_bi.vcf.gz" 
bcftools stats $vcf | grep TSTV

# TSTV, transitions/transversions:
# TSTV  [2]id   [3]ts   [4]tv   [5]ts/tv        [6]ts (1st ALT) [7]tv (1st ALT) [8]ts/tv (1st ALT)
#TSTV    0       19063810        8467424 2.25    19063810        8467424 2.25
```