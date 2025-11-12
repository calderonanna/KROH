# Fst
https://github.com/nt246/lcwgs-guide-tutorial/blob/main/tutorial3_ld_popstructure/markdowns/pca_admixture.md

## Create a bam.filelist
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/sfs"

cd $data/bam
realpath 1831*marked.bam >> $work_dir/cKIWA_bam.filelist
realpath 29779_marked.bam >> $work_dir/KIWA_bam.filelist
realpath 383194_marked.bam >> $work_dir//KIWA_bam.filelist
realpath 383202_marked.bam >> $work_dir//KIWA_bam.filelist
realpath 383205_marked.bam >> $work_dir/KIWA_bam.filelist
realpath 507264_marked.bam >> $work_dir/KIWA_bam.filelist
realpath 507265_marked.bam >> $work_dir/KIWA_bam.filelist
```

## Generate SAF 
```bash
#Contemporary 
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/saf.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=20GB
#SBATCH --time=10:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=csaf
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/sfs"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
mywa_genome="/storage/home/abc6435/ToewsLab/mywa_genome_2/final_assembly/mywagenomev2.1.fa"
angsd_tool="/storage/home/abc6435/ToewsLab/bin/angsd/angsd"

$angsd_tool -b $work_dir/cKIWA_bam.filelist \
  -ref $mywa_genome \
  -out $work_dir/cKIWA \
  -doSaf 1 \
  -anc $mywa_genome \
  -GL 1 \
  -doMajorMinor 1 \
  -doMaf 1 \
  -minMapQ 30 \
  -minQ 20 \
  -nThreads 8

$angsd_tool -b $work_dir/hKIWA_bam.filelist \
  -ref $mywa_genome \
  -out $work_dir/hKIWA \
  -doSaf 1 \
  -anc $mywa_genome \
  -GL 1 \
  -doMajorMinor 1 \
  -doMaf 1 \
  -minMapQ 30 \
  -minQ 20 \
  -nThreads 8
```

## Estimate Joint SFS (2D-SFS)
```bash 
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/2dsfs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=2dsfs
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/sfs"
realSFS="/storage/home/abc6435/ToewsLab/bin/angsd/misc/realSFS"

$realSFS $work_dir/hKIWA.saf.idx $work_dir/cKIWA.saf.idx -P 8 > $work_dir/chKIWA.sfs
```
## Comput Fst
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/fst.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=fst
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

# Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/sfs"
realSFS="/storage/home/abc6435/ToewsLab/bin/angsd/misc/realSFS"

# Step 1: FST index
$realSFS fst index \
  $work_dir/hKIWA.saf.idx \
  $work_dir/cKIWA.saf.idx \
  -sfs $work_dir/chKIWA.sfs \
  -fstout $work_dir/chKIWA

# Step 2: Global Fst
$realSFS fst stats \
  $work_dir/chKIWA.fst.idx \
  > $work_dir/chKIWA_global_fst.txt

# Step 3: Windowed Fst
cd $work_dir
$realSFS fst stats2 chKIWA.fst.idx -r chr1 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr1a -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr2 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr3 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr4 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr4a -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr5 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr6 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr7 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr8 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr9 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr10 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr11 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr12 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr13 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr14 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr15 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr17 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr18 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr19 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr20 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr21 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr22 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr23 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr24 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr25 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr26 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr27 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr28 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window
$realSFS fst stats2 chKIWA.fst.idx -r chr29 -win 10000 -step 5000 -P 8 >> chKIWA_fst.window

#clean file
cut -f2,3,5 chKIWA_fst.window >> temp && mv -f temp chKIWA_fst.window
```

## Clean File
```bash
cut -f2,3,5 chKIWA_fst.window >> temp && mv -f temp chKIWA_fst.window

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pop_structure/sfs/chKIWA_fst.window /Users/abc6435/Desktop/KROH/data/pop_structure
