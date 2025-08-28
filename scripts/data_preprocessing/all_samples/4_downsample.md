# Downsample Contemporary BAMs
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/downsample_bams.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=5GB
#SBATCH --time=05:00:00
#SBATCH --account=open
#SBATCH --job-name=downsample_bams
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
out="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam/downsampled"

samtools view -s 0.29 -b $data/183195312_marked.bam > $out/183195312_marked_downsampled.bam

samtools view -s 0.35 -b $data/183195326_marked.bam > $out/183195326_marked_downsampled.bam

samtools view -s 0.40 -b $data/183194841_marked.bam > $out/183194841_marked_downsampled.bam

samtools view -s 0.43 -b $data/183195304_marked.bam > $out/183195304_marked_downsampled.bam

samtools view -s 0.39 -b $data/183195332_marked.bam > $out/183195332_marked_downsampled.bam

samtools view -s 0.26 -b $data/183194861_marked.bam > $out/183194861_marked_downsampled.bam

samtools view -s 0.25 -b $data/183195321_marked.bam > $out/183195321_marked_downsampled.bam