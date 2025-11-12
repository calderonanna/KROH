# Simulate Missing Data
eggs -b empirical.vcf.gz -d 0.7,0.05 < simulated.vcf.gz > simulated_missing.vcf.gz

- -d, --deamin:Two comma-seperated proportions "prob1,prob2" where prob1 is the probability the site is a transition and prob2 is the probability of deamination. ts/ts+tv

## Transition (TS) and Transversions (TV)
To calculate the probability the site is a transition (prob1) use ts/(ts+tv)=0.681942
```bash
#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf" 
bcftools stats $vcf/cKIWA.vcf.gz | grep TSTV
bcftools stats $vcf/hKIWA.vcf.gz | grep TSTV

awk -v cKIWA_ts=19488132 -v cKIWA_tv=9089262 'BEGIN {print cKIWA_ts / (cKIWA_ts + cKIWA_tv)}'

awk -v hKIWA_ts=19488132 -v hKIWA_tv=9089262 'BEGIN {print hKIWA_ts / (hKIWA_ts + hKIWA_tv)}'
```

## Run EGGS
```bash
for h in $h_coef; do
    cat <<EOT > $scripts/eggs_${h}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=eggs_${h}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
h_coef="h00 h05 h10"


\$eggs -b \$emp_vcf/cKIWA.vcf.gz -d 0.681942,0.05 < \$sim_vcf/${h}/${h}_2009.vcf > \$sim_vcf/${h}/${h}_2009_eggs.vcf

\$eggs -b \$emp_vcf/hKIWA.vcf.gz -d 0.681942,0.05 < \$sim_vcf/${h}/${h}_1929.vcf > \$sim_vcf/${h}/${h}_1929_eggs.vcf

EOT
done

