
# Sequence Stats - Coverage and Readlength

## Coverage
`samtools depth -a input.bam |  awk '{sum+=$3} END { print "Average = ",sum/NR}'`
- `a`: obtains the depth at every position. 
- `awk`: sums the depth at every position and divides by number of positions.

```bash
#Run loop
for i in `cat $scripts/SETO_IDS.txt`; do 
    cat <<EOT > $scripts/cov_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=05:00:00
#SBATCH --account=open
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

#Calculate Average Depth
for i in `cat $scripts/SETO_IDS.txt`; do
    awk -v id="$i" '{ sum += $3 } END { print id, sum/NR }' $seqstats/${i}_dp.txt >> $seqstats/autocov.txt
done

sed 's/ /\t/g' $seqstats/autocov.txt
```

## Readlength
```bash
nano $scripts/readlength.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --mem=50GB
#SBATCH --account=open
#SBATCH --job-name=readlength
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"

for i in `cat $scripts/SETO_IDS.txt`; do 
    samtools view $bam/${i}_sorted_marked.bam \
    | awk '{print length($10)}' \
    >> $seqstats/${i}_rl.txt;
done 
```

