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
bin="/storage/home/abc6435/SzpiechLab/bin"
cd $bin
git clone https://github.com/ginolhac/mapDamage.git
cd mapDamage
python3 setup.py install --user

```
## Run Mapdamage
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
for i in `cat $scripts/KIWA_IDS.txt`; do
    cat<<EOT > $scripts/mapdamage_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=15GB
#SBATCH --time=100:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=standard
#SBATCH --job-name=mapdamage_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference/mywagenomev2.1.fa"

#Load Modules
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

#Define R Library Path
export R_LIBS_USER="/storage/group/zps5164/default/bin/.R"

#Make Directory
if [ ! -d "\$work/${i}" ]; then
    mkdir -p "\$work/${i}"
fi

# Run MapDamage
\$bin/mapDamage \\
    -i \$bam/${i}_marked.bam \\
    -r \$ref \\
    -d \$work/${i} \\
    -l 20 \\
    -m 15 \\
    -Q 15 \\
    --merge-libraries \\
    --rescale
EOT
done

#submit
for i in `cat $scripts/KIWA_IDS.txt`; do
    sbatch $scripts/mapdamage_${i}.bash;
done
```

## Compile Misincorporation Results
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"

#Historical
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $work/29779/misincorporation.txt | head -1 > $work/misincorp_results_h.txt

for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $work/${i}/misincorporation.txt \
        | sed '1d' \
        >> $work/misincorp_results_h.txt;
done

#Contemporary 
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $work/29779/misincorporation.txt | head -1 > $work/misincorp_results_c.txt

for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $work/${i}/misincorporation.txt \
        | sed '1d' \
        >> $work/misincorp_results_c.txt;
done

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage/misincorp_results_*.txt /Users/abc6435/Desktop/KROH/data/mapdamage
```

## Compile DNA Composition Results
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"

#Historical
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $work/29779/dnacomp.txt | head -1 > $work/dnacomp_results_h.txt

for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $work/${i}/dnacomp.txt \
        | sed '1d' \
        >> $work/dnacomp_results_h.txt;
done

#Contemporary
awk -v sample="Sample" '{print sample, $0}' OFS='\t' $work/29779/dnacomp.txt | head -1 > $work/dnacomp_results_c.txt

for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print sample, $0}' OFS='\t' $work/${i}/dnacomp.txt \
        | sed '1d' \
        >> $work/dnacomp_results_c.txt;
done

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage/dnacomp_results_*.txt /Users/abc6435/Desktop/KROH/data/mapdamage
```
## Compile MCMC Stats
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage"

#Historical
for i in `cat $scripts/hKIWA_IDS.txt`; do
    cat $work/${i}/Stats_out_MCMC_iter_summ_stat.csv \
    | tr "," "\t" > $work/${i}/Stats_out_MCMC_iter_summ_stat.tsv;
done

awk -v sample="Sample" '{print $0, sample}' OFS='\t' $work/29779/Stats_out_MCMC_iter_summ_stat.tsv | head -1 > $work/stats_out_mcmc_iter_summ_results_h.tsv

for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print $0, sample}' OFS='\t' $work/${i}/Stats_out_MCMC_iter_summ_stat.tsv \
        | sed '1d' \
        >> $work/stats_out_mcmc_iter_summ_results_h.tsv;
done


#Contemporary
for i in `cat $scripts/cKIWA_IDS.txt`; do
    cat $work/${i}/Stats_out_MCMC_iter_summ_stat.csv \
    | tr "," "\t" > $work/${i}/Stats_out_MCMC_iter_summ_stat.tsv;
done

awk -v sample="Sample" '{print $0, sample}' OFS='\t' $work/29779/Stats_out_MCMC_iter_summ_stat.tsv | head -1 > $work/stats_out_mcmc_iter_summ_results_c.tsv

for i in `cat $scripts/cKIWA_IDS.txt`; do
    awk -v sample="${i}" '{print $0, sample}' OFS='\t' $work/${i}/Stats_out_MCMC_iter_summ_stat.tsv \
        | sed '1d' \
        >> $work/stats_out_mcmc_iter_summ_results_c.tsv;
done

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mapdamage/stats_out_mcmc_iter_summ_results_*.tsv /Users/abc6435/Desktop/KROH/data/mapdamage