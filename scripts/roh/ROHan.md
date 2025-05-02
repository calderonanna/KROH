# ROHan

## Installation
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

# Clone ROHan
git clone --depth 1 https://github.com/grenaud/rohan.git
cd ROHan
make

# bam2prof didn't install correctly
cd bam2prof
nano make
#change CXXFLAGS = -std=c++11 to CXXFLAGS = -std=c++17
make clean
make
```

## Run bam2prof
Scans aligned reads and computes nucleotide substitition near the 5' and 3' ends to detect post-mortem DNA damage which is a characterisitc of aDNA
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
for i in `cat $scripts/hKIWA_IDS.txt`; do 
    cat <<EOT > $scripts/bam2prof_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=2:00:00
#SBATCH --account=open
#SBATCH --job-name=bam2prof_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/rohan"

#load GSL
module load gsl

#Run bam2prof
\$rohan/bam2prof/bam2prof \\
    -minq 30 \\
    -minl 35 \\
    -length 10 \\
    -double \\
    -paired \\
    -classic \\
    -5p \$work_dir/${i}_5p.prof \\
    -3p \$work_dir/${i}_3p.prof \\
    -o \$work_dir \\
    \$data/${i}.bam 
EOT
done

for i in `cat $scripts/hKIWA_IDS.txt`; do 
    sbatch $scripts/bam2prof_${i}.bash;
done

```

## Compile Results
```bash
#Set Variables
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/rohan"

for i in `cat $scripts/hKIWA_IDS.txt`; do 
    awk -v tag="FIVE_PRIME" -v sample=${i} '{print tag, sample, $0}' OFS='\t' ${i}_marked_classic_*_5p.prof >> 5p_results.txt;
done

for i in `cat $scripts/hKIWA_IDS.txt`; do 
    awk -v tag="THREE_PRIME" -v sample=${i} '{print tag, sample, $0}' OFS='\t' ${i}_marked_classic_*_3p.prof >> 3p_results.txt;
done
