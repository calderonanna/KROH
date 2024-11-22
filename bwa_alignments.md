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

#Add bwa to your $PATH and then add it permanently to bashrc
export PATH=/storage/home/abc6435/SzpiechLab/bin/bwa:$PATH
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/bwa:$PATH' >> ~/.bashrc
source ~/.bashrc

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
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/bwa_index_ref.bash
--------------------NANO------------------
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=5GB
#SBATCH --time=1:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_index_ref
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
ref_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"

#Move to reference folder
cd $ref_folder

#Run BWA with the bwtsw algorithm
bwa index -p mywagenomev2.1 -a bwtsw $ref_folder/mywagenomev2.1.fa
--------------------EOS-------------------
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

```bash
#Make a directory for sam files
mkdir ~/SzpiechLab/abc6435/KROH/data/sam

scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

for i in `cat $scripts_folder/cKIWA_IDS.txt`; do echo"
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=5GB
#SBATCH --time=1:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_alignments_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

bwa mem -R "@RG\tSM:${i}" -M -t 2 \
$mywa_folder/mywagenomev2.1.fa \
$data_folder/trimmed/${i}_trimmed.pair1.truncated.gz \
$data_folder/trimmed/${i}_trimmed.pair2.truncated.gz \ > $data_folder/sam/${i}.sam \
2> $err_folder/${i}_bwa.err"; done

```
