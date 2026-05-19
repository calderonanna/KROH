# MapDamage
## Installation
```bash
#Install Necessary R Packages
Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('gam', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('RcppGSL', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('inline', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('Rcpp', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('ggplot2', lib='/storage/group/zps5164/default/bin/.R')"

#Export R Library path
export R_LIBS_USER="/storage/group/zps5164/default/bin/.R"

# Git Install mapDamage
python3 -m venv ~/mapdamage_env
source ~/mapdamage_env/bin/activate
pip install /storage/home/abc6435/SzpiechLab/bin/mapDamage
mapDamage --version


```
## Run Mapdamage hKIWA
```bash
for i in `cat $scripts/hKIWA_IDS_e759877.txt`; do
    cat<<EOT > $scripts/mapdamage_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=1GB
#SBATCH --time=24:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=mapdamage_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"

#Load Modules and Define R Lib Path
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0
export R_LIBS_USER="/storage/group/zps5164/default/bin/.R"
source ~/mapdamage_env/bin/activate

# Run MapDamage
mapDamage \\
    -i \$bam/${i}_sorted_marked.bam \\
    -r \$ref \\
    -d \$work/${i} \\
    -l 20 \\
    -m 15 \\
    -Q 15 \\
    --merge-libraries \\
    --rescale

# Move re-scaled bams
mv \$work/${i}/${i}_sorted_marked.rescaled.bam \$bam

EOT
done
```

## Run Mapdamage cKIWA
```bash
for i in `cat $scripts/cKIWA_IDS.txt`; do
    cat<<EOT > $scripts/mapdamage_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=1GB
#SBATCH --time=24:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=mapdamage_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"

#Load Modules and Define R Lib Path
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0
export R_LIBS_USER="/storage/group/zps5164/default/bin/.R"
source ~/mapdamage_env/bin/activate

# Run MapDamage
mapDamage \\
    -i \$bam/${i}_sorted_marked_down.bam \\
    -r \$ref \\
    -d \$work/${i} \\
    -l 20 \\
    -m 15 \\
    -Q 15 \\
    --merge-libraries \\
    --rescale

# Move re-scaled bams
mv \$work/${i}/${i}_sorted_marked_down.rescaled.bam \$bam

EOT
done
```

## Compile Results
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
seqstats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats"
mapdamage="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"

#Misincorporation
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $mapdamage/29779/misincorporation.txt | head -1 | cut --complement -f2 > $seqstats/misincorporation.txt
for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $mapdamage/${i}/misincorporation.txt \
        | sed '1d' \
        | sed 's/*/historical/g' \
        | cut --complement -f2 \
        >> $seqstats/misincorporation.txt;
done
for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $mapdamage/${i}/misincorporation.txt \
        | sed '1d' \
        | sed 's/*/contemporary/g' \
        | cut --complement -f2 \
        >> $seqstats/misincorporation.txt;
done



#DNA Composition
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $mapdamage/29779/dnacomp.txt | head -1 | cut --complement -f2 > $seqstats/dnacomp.txt
for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $mapdamage/${i}/dnacomp.txt \
        | sed '1d' \
        | sed 's/*/historical/g' \
        | cut --complement -f2 \
        >> $seqstats/dnacomp.txt;
done
for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $mapdamage/${i}/dnacomp.txt \
        | sed '1d' \
        | sed 's/*/contemporary/g' \
        | cut --complement -f2 \
        >> $seqstats/dnacomp.txt;
done

#MCMC Stats
for i in `cat $scripts/KIWA_IDS.txt`; do
    cat $mapdamage/${i}/Stats_out_MCMC_iter.csv \
    | tr "," "\t" > $mapdamage/${i}/Stats_out_MCMC_iter.tsv;
done

echo "Iter  Theta   DeltaD  DeltaS  Lambda  Rho LogLik  Sample  Pop" > $seqstats/Stats_out_MCMC_iter.tsv
for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print $0, sample, "historical"}' OFS='\t' $mapdamage/${i}/Stats_out_MCMC_iter.tsv \
    | sed '1d' \
    >> $seqstats/Stats_out_MCMC_iter.tsv;
done
for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print $0, sample, "contemporary"}' OFS='\t' $mapdamage/${i}/Stats_out_MCMC_iter.tsv \
    | sed '1d' \
    >> $seqstats/Stats_out_MCMC_iter.tsv;
done

```
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats/dnacomp.txt /Users/abc6435/Desktop/KROH/data/mapdamage
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats/misincorporation.txt /Users/abc6435/Desktop/KROH/data/mapdamage
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seqstats/Stats_out_MCMC_iter.tsv /Users/abc6435/Desktop/KROH/data/mapdamage
```