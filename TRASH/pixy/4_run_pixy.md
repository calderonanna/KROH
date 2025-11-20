# Pixy
https://pixy.readthedocs.io/en/latest/arguments.html

## Filter VCF
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#Filter Sites and Index
bcftools view -M2 -i '((ALT="." && INFO/DP>10) || (ALT!="." && STRLEN(REF)==1 && STRLEN(ALT)==1 && INFO/DP>10 && QUAL>=30))' $allsites/KIWA_allsites.vcf.gz -Oz -o $allsites/KIWA_allsites_bi_dp_qual.vcf.gz

bcftools view -i 'N_MISSING = 0' $allsites/KIWA_allsites_bi_dp_qual.vcf.gz
 -Oz -o $allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz

nohup tabix $allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz
```

## Run Pixy: Sites
```bash
for i in $(cat $scripts/autochrs.txt);do
    cat <<EOT > $scripts/pixy_pi_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_hc_default
#SBATCH --job-name=pixy_pi_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

# Load Python 3.11.2
module load python/3.11.2
python3 --version

# Activate pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

# Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#Run Pixy
pixy --stats pi \\
  --vcf "\$allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz" \\
  --populations "\$pixy/pops.txt" \\
  --n_cores 4 \\
  --chromosomes "${i}" \\
  --window_size 1 \\
  --output_folder \$pixy \\
  --output_prefix ${i}
EOT
done
```

## Run Pixy: Windows
```bash
nano $scripts/pixy_pi_window.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_hc_default
#SBATCH --job-name=pixy_pi_window
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

# Load Python 3.11.2
module load python/3.11.2
python3 --version

# Activate pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

# Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#Run Pixy
pixy --stats pi \
  --vcf $allsites/KIWA_allsites_bi_dp_qual_nmiss.vcf.gz \
  --populations $pixy/pops.txt \
  --n_cores 4 \
  --window_size 100000 \
  --output_folder $pixy \
  --output_prefix 100kb