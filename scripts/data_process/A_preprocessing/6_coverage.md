
# Coverage 

`samtools depth -a input.bam |  awk '{sum+=$3} END { print "Average = ",sum/NR}'`
- `a`: obtains the depth at every position. 
- `awk`: sums the depth at every position and divides by number of positions.

## All Samples
```bash
for i in `cat $scripts/SETO_IDS.txt`; do 
    cat <<EOT > $scripts/cov_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --partition=standard
#SBATCH --job-name=cov_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Extract Depth
samtools depth -a \$bam/${i}_sorted_marked.bam > \$seqstats/${i}_dp.txt

#Remove mito, scafolds, and chrz
sed -i '/^scaffold/d; /^mito/d; /^chrz/d' \$seqstats/${i}_dp.txt
EOT
done
```
## Downsampled Samples
```bash
for i in `cat $scripts/cKIWA_IDS.txt`; do 
    cat <<EOT > $scripts/cov_down_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --partition=standard
#SBATCH --job-name=cov_down_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Extract Depth
samtools depth -a \$bam/${i}_sorted_marked_down.rescaled.bam > \$seqstats/${i}_down_dp.txt

#Remove mito, scafolds, and chrz
sed -i '/^scaffold/d; /^mito/d; /^chrz/d' \$seqstats/${i}_down_dp.txt
EOT
done
```

# Calculate Average Depth
```bash
nano $scripts/average_coverage.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --partition=basic
#SBATCH --job-name=average_coverage
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables 
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#All Samples
for i in `cat $scripts/SETO_IDS.txt`; do
    awk -v id="$i" '{ sum += $3 } END { print id, sum/NR }' $seqstats/${i}_dp.txt >> $seqstats/coverage.txt
done

#Downsampled
for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v id="$i_down" '{ sum += $3 } END { print id, sum/NR }' $seqstats/${i}_down_dp.txt >> $seqstats/coverage.txt
done

sed -i 's/ /\t/g' $seqstats/coverage.txt
```

