# Genotype Likelihoods

## ANGSD
`-doMajorMinor 1`: infers both major and minor alleles.
`-doMaf 1`: Estimates minor allele frequencies. 
`-GL 1`: Generates genotype likelihoods using SAMTools method. 
`-doCounts 1`: Counts reads per base (A,T,C,G) for each site and sample. 
`-minMapQ 30`: Only reads with mapping quality above 30 are considered. 
`-mapQ 20`: Filters out low-confidence base calls. 
`-remove_bads 1`:Removes read with a flag above 255; bad reads like unmapped reads, QC-failed, duplicates. 
`-only-proper-pairs 1`: keeps reads that were paired properly. 
`-uniqueOnly 1`: Remove reads that mapped to multiple regions.
`-C 50`: If a read has many mismatches, the effective mapping quality is reduced.
`-baq 1`: Bases near potential misalignments (like around indels or in repetitive regions) get lowered base quality scores. Helps reduce false positive SNPs. 

```bash
nano $scripts/angsd.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=8GB
#SBATCH --time=200:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=standard
#SBATCH --job-name=angsd
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
angsd='/storage/home/abc6435/ToewsLab/bin/angsd/angsd'
ref='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa'
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Index reference 
cd $basedir/mywa_reference/
samtools faidx mywagenomev2.1.fa

#Run ANGSD
# $angsd -b $basedir/rxy/cKIWA_bamlist.txt -ref $ref -out $basedir/rxy/cKIWA -GL 1 -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

# $angsd -b $basedir/rxy/hKIWA_bamlist.txt -ref $ref -out $basedir/rxy/hKIWA -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

# $angsd -b $basedir/rxy/HOWA_AMRE_bamlist.txt -ref $ref -out $basedir/rxy/HOWA_AMRE -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

$angsd -b $basedir/rxy/chKIWA_bamlist.txt -ref $ref -out $basedir/rxy/chKIWA -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8
```