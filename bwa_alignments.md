# Aligning Contemporary Samples with BWA
https://bio-bwa.sourceforge.net/bwa.shtml

BWA maps low-divergent sequences against a large reference genomes. It consists of three algorithms: 
- BWA-backtrack: Designed for Illumina sequence read up to 100pb.

- BWA-SW: Long read sequncing 70bp-1Mb.

- BWA-MEM: Long read sequncing 70bp-1Mb. Recommended for high-quality queries as it is faster and more accurate. Better performance than BWA-backtrack for 70-100bp Illumina reads.

## Installation
Installing using git clone from https://github.com/lh3/bwa
```bash
#Install to lab bin
cd /storage/home/abc6435/SzpiechLab/bin

git clone https://github.com/lh3/bwa.git
cd bwa; make
```


## File Prep
I'm going to move the trimmed contemporary files from the WarblerROH folder into the KROH folder
```bash
#Set Variables
WarblerROH_folder="/storage/home/abc6435/SzpiechLab/abc6435/WarblerROH"

KROH_data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

KROH_scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Moving trimmed contemporary files to KROH
for i in `cat $KROH_scripts/cKIWA_IDS.txt`; do mv $WarblerROH_folder/${i}/${i}_trimmed* $KROH_data_folder/trimmed; done
```

## Indexing the Reference
Memory requirements (time estimate: 3hrs):
- bwtsw: 5GB (human genome)
- aln (short reads): ~3.2GB
- sampe: 5.4GB

`bwa index -p mywagenomev2.1 -a bwtsw mywagenomev2.1.fa`

```bash
#Set Variables
ref_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"

#Move to reference folder
cd $ref_folder

#Run BWA with the bwtsw algorithm
bwa index -p mywagenomev2.1 -a bwtsw $ref_folder/mywagenomev2.1.fa
```

## Aligning the contemporary samples
`bwa mem -R "@RG\tSM:sample1" -M -t 2 \
reference.fasta \
trimmed.pair1.truncated.gz \
trimmed.pair2.truncated.gz \ > aligned_reads.sam \
2> logs/bwa.err`

- bwa mem: Aligns paired-end reads to a reference genome
- -M: Mark shorter split hits as secondary (for Picard compatibility).
- -R: Read group information
- -t: Number of threads
- 2> logs/bwa.err: Redirects stderr (error messages) to the log file logs/bwa.err

