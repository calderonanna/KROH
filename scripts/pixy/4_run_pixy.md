# Pixy
https://pixy.readthedocs.io/en/latest/arguments.html

```bash
nano $scripts/pixy_pi.bash
#!/bin/bash
#SBATCH --nodes=1
#SBARCH --ntasks=8
#SBATCH --mem=100GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=pixy_pi
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Load Python 3.11.2
module load python/3.11.2
module use python/3.11.2
python3 --version

#Activate pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

# #Filter Sites and Index
# bcftools view -M2 -i '((ALT="." && INFO/DP>10) || (ALT!="." && STRLEN(REF)==1 && STRLEN(ALT)==1 && INFO/DP>10 && QUAL>=30))' $allsites/KIWA_allsites.vcf.gz -Oz -o $allsites/KIWA_allsites_bi_dp_qual.vcf.gz
# nohup tabix $allsites/KIWA_allsites_bi_dp_qual.vcf.gz

#Intergenic Sites
bedtools makewindows -b $pixy/intergenic.bed -w 1 | sed 1d | cut -f1,2 > $pixy/intergenic.txt

pixy --stats pi \
--vcf $allsites/KIWA_allsites.vcf.gz \
--populations $pixy/2pops.txt \
--n_cores 8 \
--sites_file $pixy/intergenic.txt \
--output_folder $pixy \
--output_prefix intergenic_2pops

# #Genomewide
# pixy --stats pi \
# --vcf $allsites/KIWA_allsites.vcf.gz \
# --populations $pixy/2pops.txt \
# --n_cores 8 \
# --window_size 100000 \
# --output_folder $pixy \
# --output_prefix genomewide_2pops

#Average Pi
awk 'NR>1 && $1=="cKIWA" {sum+=$5; count++} END {print "cKIWA intergenic_pi =",sum/count}' $pixy/intergenic_2pops_pi.txt >> $pixy/avg_neutral_pi.txt
awk 'NR>1 && $1=="hKIWA" {sum+=$5; count++} END {print "hKIWA intergenic_pi =",sum/count}' $pixy/intergenic_2pops_pi.txt >> $pixy/avg_neutral_pi.txt
```
