# Split .fa

```bash
nano $scripts/rhino_split.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=100GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=rhino_split
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"
fastq="/storage/group/zps5164/default/shared/rhinos/fastq"
seqkit="/storage/home/abc6435/SzpiechLab/bin/seqkit"

$seqkit split2 \
    -p 10 -O $fastq/split \
    -1 $fastq/BR18_trim.pair1.truncated.gz \
    -2 $fastq/BR18_trim.pair2.truncated.gz

$seqkit split2 -p 10 -O $fastq/split BR18_trim.collapsed.gz

zcat $fastq/split/BR18_trim.pair1.part_001.truncated.gz | head -400000 > test_R1.fq
zcat $fastq/split/BR18_trim.pair2.part_001.truncated.gz | head -400000 > test_R2.fq
zcat $fastq/split/BR18_trim.part_001.collapsed.gz | head -400000 > test_collapsed.fq


```
