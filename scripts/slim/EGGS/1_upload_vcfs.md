# EGGS

## Upload VCFs
```bash
#Set Variables
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
slim="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"
h_coef="h00 h05 h10"

#Upload VCFs
for h in $h_coef; do
    scp /Users/abc6435/Desktop/KROH/data/slim/rxy/${h}/${h}_*.vcf abc6435@submit.hpc.psu.edu://storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs/${h}
done
```