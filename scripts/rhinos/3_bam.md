# BAM
`samtools view -S -b sample.sam > sample.bam`

**-S**: specifies that the input file is a sam file
**-b**: species that we want to produce a bam file
**>**: denotes where to store the output bam file. 

```bash
nano $scripts/rhino_bam_coverage.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=50:00:00
#SBATCH --account=zps5164_sc_default
#SBATCH --job-name=rhino_bam_coverage
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"

#sam to bam
samtools view -S -b ~/scratch/BR18.sam > ~/scratch/BR18.bam

#sort bam
samtools sort ~/scratch/BR18.bam -T ~/scratch/BR18_temp.bam -o ~/scratch/BR18_sort.bam

#Index 
samtools index ~/scratch/BR18_sort.bam ~/scratch/BR18_sort.bai

#Calculate Coverage
samtools depth -a ~/scratch/BR18_sort.bam >> ~/scratch/BR18_dp.txt
awk '{sum+=$3} END {print sum/NR}' ~/scratch/BR18_dp.txt >> ~/scratch/BR18_genomewide_coverage.txt
```
