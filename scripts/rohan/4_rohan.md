# ROHan

## hKIWA
```bash
for i in $(cat $scripts/hKIWA_IDS_e759877.txt); do
    cat <<EOT > $scripts/rohan_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=50GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=rohan_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan/bin/rohan"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan"
results="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan/results"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"

#load GSL
module load gsl
module use gsl

\$rohan \\
-t 8 \\
--tstv 2.03 \\
--rohmu 1.5e-04 \\
--name ${i} \\
--deam5p \$work/${i}_5p.prof \\
--deam3p \$work/${i}_3p.prof \\
--auto \$scripts/autochrs.txt \\
--size 1000000 \\
-o \$results/${i} \\
\$ref \\
\$bam/${i}_sorted_marked_rescaled_qc.bam \\
> \$results/${i}.log \\
2> \$results/${i}.err
EOT
done
```

## cKIWA
```bash
for i in $(cat $scripts/cKIWA_IDS.txt); do
    cat <<EOT > $scripts/rohan_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=50GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=rohan_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan/bin/rohan"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan"
results="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan/results"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"

#load GSL
module load gsl
module use gsl

\$rohan \\
-t 8 \\
--tstv 2.03 \\
--rohmu 1.5e-04 \\
--name ${i} \\
--deam5p \$work/${i}_5p.prof \\
--deam3p \$work/${i}_3p.prof \\
--auto \$scripts/autochrs.txt \\
--size 1000000 \\
-o \$results/${i} \\
\$ref \\
\$bam/${i}_sorted_marked_down_rescaled_qc.bam \\
> \$results/${i}.log \\
2> \$results/${i}.err
EOT
done
```