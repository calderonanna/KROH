# Concatenate

```bash
nano $scripts/rhino_concat.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=8GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=rhino_concat
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"
ref="/storage/group/zps5164/default/shared/reference_genomes/black_rhino"
fastq="/storage/group/zps5164/default/shared/rhinos/fastq"

#Concatenate
cd $fastq
# zcat *L004_R1.fastq.gz *L005_R1.fastq.gz *L006_R1.fastq.gz *L007_R1.fastq.gz >> BR18_R1.fastq 

#zcat *L004_R2.fastq.gz *L005_R2.fastq.gz *L006_R2.fastq.gz *L007_R2.fastq.gz >> BR18_R2.fastq 

#Zip
# gzip $fastq/BR18_R1.fastq
gzip $fastq/BR18_R2.fastq
```