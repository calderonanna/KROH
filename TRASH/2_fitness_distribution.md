# Fitness Distribution

## Extract Selection Coefficients
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"

#Obtain selection coefficients
bcftools query -f '%INFO/S' $work/d00/d00_chr1_fmiss.vcf.gz > $work/d00/d00_s.txt
```

## Download to Local
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
rsync abc6435@submit.hpc.psu.edu:$work/d00/d00_s.txt /Users/abc6435/Desktop/KROH/data/slim/rxy/d00
```
## Analyze in R
