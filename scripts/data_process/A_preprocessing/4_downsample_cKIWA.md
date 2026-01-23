# Downsample cKIWA
```bash
nano $scripts/downsample.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=downsample
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

samtools view -s 0.26690154 -b $bam/183194841_sorted_marked.bam > $bam/183194841_sorted_marked_down.bam

samtools view -s 0.2646500334 -b $bam/183195332_sorted_marked.bam > $bam/183195332_sorted_marked_down.bam

samtools view -s 0.1746869828 -b $bam/183194861_sorted_marked.bam > $bam/183194861_sorted_marked_down.bam

samtools view -s 0.1676481066 -b $bam/183195321_sorted_marked.bam > $bam/183195321_sorted_marked_down.bam

samtools view -s 0.286037099 -b $bam/183195304_sorted_marked.bam > $bam/183195304_sorted_marked_down.bam

samtools view -s 0.243350449 -b $bam/183195326_sorted_marked.bam > $bam/183195326_sorted_marked_down.bam

samtools view -s 0.1961524693 -b $bam/183195312_sorted_marked.bam > $bam/183195312_sorted_marked_down.bam

#Re-Calculate Coverage
for i in `cat $scripts/cKIWA_IDS.txt`; do
    samtools depth -a $bam/${i}_sorted_marked_down.bam > $seqstats/${i}_down_dp.txt
    sed -i '/^scaffold/d; /^mito/d; /^chrz/d' $seqstats/${i}_down_dp.txt
    awk -v id="$i" '{ sum += $3 } END { print id"_down", sum/NR }' $seqstats/${i}_down_dp.txt >> $seqstats/autocov.txt
done
