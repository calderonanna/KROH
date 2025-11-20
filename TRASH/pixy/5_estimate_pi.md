# Estimate Pi

```bash
nano $scripts/pixy_gw_pi.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=6:00:00
#SBATCH --account=open
#SBATCH --job-name=pixy_gw_pi
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"

cd $pixy

#Parse Data
for i in $(cat $scripts/autochrs.txt); do
    sed 1d ${i}_pi.txt \
    | grep -v "NA" \
    | grep "cKIWA" \
    >> cKIWA_pi.txt
done

for i in $(cat $scripts/autochrs.txt); do
    sed 1d ${i}_pi.txt \
    | grep -v "NA" \
    | grep "hKIWA" \
    >> hKIWA_pi.txt
done

# Summarize Pairwise Differences, Comparsions, and Sequence Length
awk '{sum_diff+=$7; sum_comp+=$8; count++} END {print "hKIWA", sum_diff, sum_comp, sum_diff/sum_comp}' OFS="\t" hKIWA_pi.txt >> genomewide_pi.txt

awk '{sum_diff+=$7; sum_comp+=$8; count++} END {print "cKIWA", sum_diff, sum_comp, sum_diff/sum_comp}' OFS="\t" cKIWA_pi.txt >> genomewide_pi.txt







