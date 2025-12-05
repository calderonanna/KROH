# Pixy Sites
https://pixy.readthedocs.io/en/latest/arguments.html

## Pop Files
Headerless tab separated file with col1 as sample names and col2 as population id. 
```bash
# Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

yes "cKIWA" | head -n 7 >> $pixy/ids.tmp
yes "hKIWA" | head -n 6 >> $pixy/ids.tmp
paste $scripts/KIWA_IDS_e759877.txt $pixy/ids.tmp >> $pixy/pops.txt
rm -rf $pixy/ids.tmp
```

## Run Pixy
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

# Activate pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

# Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#Run Pixy
pixy --stats pi \\
  --vcf "\$allsites/dKIWA_allsites_bi_dp_qual.vcf.gz" \\
  --populations "\$pixy/pops.txt" \\
  --n_cores 4 \\
  --chromosomes "${i}" \\
  --window_size 1 \\
  --output_folder \$pixy \\
  --output_prefix ${i}_sites
EOT
done
```
