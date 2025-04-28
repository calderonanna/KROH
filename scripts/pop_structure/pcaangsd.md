# PCAANGSD
https://github.com/nt246/lcwgs-guide-tutorial/blob/main/tutorial3_ld_popstructure/markdowns/pca_admixture.md

## Create a bam.filelist
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

cd $data/bam
realpath 1831*marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 29779_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 383194_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 383202_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 383205_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 507264_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
realpath 507265_marked.bam >> $data/pop_structure/pca/KIWA_bam.filelist
```

## Generate Genotype Likelihoods in Beagle Format
```bash
nano $scripts/gl_beagle.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mem=8GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=standard
#SBATCH --job-name=gl_beagle
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
mywa_genome="/storage/home/abc6435/ToewsLab/mywa_genome_2/final_assembly/mywagenomev2.1.fa"
angsd_tool="/storage/home/abc6435/ToewsLab/bin/angsd/angsd"

$angsd_tool -GL 2 -out $data/pop_structure/pca/KIWA_genolike -nThreads 10 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -bam $data/pop_structure/pca/KIWA_bam.filelist
```

## Run PCANGSD
```bash
nano $scripts/pcangsd.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mem=50GB
#SBATCH --time=2:00:00
#SBATCH --account=open
#SBATCH --job-name=pcangsd
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out


#Set variables
pcangsd_py="/storage/home/abc6435/ToewsLab/bin/pcangsd/pcangsd.py"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/pca"

#Run pcangsd
python $pcangsd_py -beagle $work_dir/KIWA_genolike.beagle.gz -out  $work_dir/output -threads 10
```
## Plot PCA in R
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/hWROH/data/pca/output.cov /Users/abc6435/Desktop/hWROH/data
```