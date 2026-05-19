## Pixy Windows
```bash
nano $scripts/pixy_pi_window.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=8:00:00
#SBATCH --account=open
#SBATCH --job-name=pixy_pi_window
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
pixy --stats pi \
  --vcf $allsites/dKIWA_allsites_bi_dp_qual.vcf.gz \
  --populations $pixy/pops.txt \
  --n_cores 4 \
  --window_size 100000 \
  --output_folder $pixy \
  --output_prefix window