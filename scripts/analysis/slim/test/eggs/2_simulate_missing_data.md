# Simulate Missing Data
https://github.com/TQ-Smith/EGGS
eggs -b empirical.vcf.gz -d 0.7,0.05 < simulated.vcf.gz > simulated_missing.vcf.gz

- -d, --deamin:Two comma-seperated proportions "prob1,prob2" where prob1 is the probability the site is a transition and prob2 is the probability of deamination. ts/ts+tv

## h00
```bash
nano $scripts/eggs_h00.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=eggs_h00
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs/h00"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"

#Run Eggs
for i in {1..100}; do 
    $eggs \
        -b $emp_vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h00_2009_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h00_2009_eggs_R${i}.vcf.gz

    $eggs \
        -b $emp_vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h00_1929_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h00_1929_eggs_R${i}.vcf.gz
done
```
## h05
```bash
nano $scripts/eggs_h05.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=eggs_h05
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs/h05"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"

#Run Eggs
for i in {1..100}; do 
    $eggs \
        -b $emp_vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h05_2009_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h05_2009_eggs_R${i}.vcf.gz

    $eggs \
        -b $emp_vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h05_1929_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h05_1929_eggs_R${i}.vcf.gz
done
```

## h10
```bash
nano $scripts/eggs_h10.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=eggs_h10
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/eggs/h10"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"

#Run Eggs
for i in {1..100}; do 
    $eggs \
        -b $emp_vcf/dcKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h10_2009_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h10_2009_eggs_R${i}.vcf.gz

    $eggs \
        -b $emp_vcf/hKIWA_auto_bi_qual_dp_gq.vcf.gz \
        -d 0.674559,0.05 -k \
        < $sim_vcf/h10_1929_reheadered_R${i}.vcf.gz \
        > $sim_vcf/eggs/h10_1929_eggs_R${i}.vcf.gz
done
```

