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
nano $scripts/angsd_downsampled.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=8GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=angsd_downsampled
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
angsd='/storage/home/abc6435/ToewsLab/bin/angsd/angsd'
ref='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa'
work='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Index reference 
cd $data/mywa_reference
samtools faidx $ref

#Create bamlist
for i in `cat $scripts/cKIWA_IDS.txt`; do
    realpath $bam/${i}_sorted_marked.rescaled.bam >> $work/maf/cKIWA.bamlist;
done

for i in `cat $scripts/hKIWA_IDS_e759877.txt`; do
    realpath $bam/${i}_sorted_marked.rescaled.bam >> $work/maf/hKIWA.bamlist;
done

for i in `cat $scripts/KIWA_IDS_e759877.txt`; do
    realpath $bam/${i}_sorted_marked.rescaled.bam >> $work/maf/chKIWA.bamlist;
done

for i in  `cat $scripts/HOWA_AMRE_IDS.txt`; do
    realpath $bam/${i}_sorted_marked.bam >> $work/maf/AMRE_HOWA.bamlist; 
done

#chKIWA
$angsd -b $work/maf/chKIWA.bamlist -ref $ref -out $work/maf/chKIWA -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

#cKIWA
$angsd -b $work/maf/cKIWA.bamlist -ref $ref -out $work/maf/cKIWA -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

#hKIWA
$angsd -b $work/maf/hKIWA.bamlist -ref $ref -out $work/maf/hKIWA -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8

#AMRE_HOWA
$angsd -b $work/maf/HOWA_AMRE.bamlist -ref $ref -out $work/maf/HOWA_AMRE -GL 1  -doMajorMinor 1 -doMaf 1 -doCounts 1 -minMapQ 30 -minQ 20 -remove_bads 1 -only_proper_pairs 1 -uniqueOnly 1 -C 50 -baq 1 -nThreads 8
```