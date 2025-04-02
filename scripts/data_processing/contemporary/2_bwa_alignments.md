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

## Index Reference
`bwa index -p mywagenomev2.1 -a bwtsw mywagenomev2.1.fa`
- `bwtsw`: 5GB (human genome)
- `aln`: ~3.2GB (short reads)
- `sampe`: 5.4GB

```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/bwa_index_ref.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=5GB
#SBATCH --time=1:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_index_ref
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
ref_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"

#Move to reference folder
cd $ref_folder

#Run BWA with the bwtsw algorithm
bwa index -p mywagenomev2.1 -a bwtsw $ref_folder/mywagenomev2.1.fa
```

## Create Scripts
`bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 2 \
reference. \
${i}_pair1.truncated.gz \
${i}_.pair2.truncated.gz > ${i}.sam 2> logs/${i}_bwa.err`

- `bwa mem`: Aligns paired-end reads to a reference genome
- `-M`: Mark shorter split hits as secondary (for Picard compatibility).
- `-R`: Read group information
- `-t`: Number of threads
- `2> logs/bwa.err`: Redirects stderr (error messages) to the log file logs/bwa.err

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Make a directory for sam files
if [ ! -d "$data_folder/sam" ]; then
    mkdir -p "$data_folder/sam"
fi

#Create a script for each contemporary file
for i in `cat $scripts_folder/HOWA_AMRE_cKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/bwa_alignments_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=bwa_alignments_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Run BWA (with resource profiling)
/usr/bin/time -v bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 4 \\
\$mywa_folder/mywagenomev2.1 \\
\$data_folder/trim/${i}_R1_trimmed.fastq.gz \\
\$data_folder/trim/${i}_R2_trimmed.fastq.gz > \$data_folder/sam/${i}.sam 2> \$err_folder/${i}_bwa.err
EOT
done

#Submit Each Script
for i in `cat $scripts_folder/HOWA_AMRE_cKIWA_IDS.txt`; do
    sbatch $scripts_folder/bwa_alignments_${i}.bash;
done

#Check Job
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```

## Alignment Stats
```bash
#Set Variable
sam_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sam"
for i in $sam_folder/*.sam; do
    echo "$(basename ${i})" >> $sam_folder/alignment_stats.txt
    echo "----------------------" >> $sam_folder/alignment_stats.txt
    samtools flagstat ${i} >> $sam_folder/alignment_stats.txt
    echo " " >> $sam_folder/alignment_stats.txt
done
```