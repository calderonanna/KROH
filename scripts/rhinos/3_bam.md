# BAM
`samtools view -S -b sample.sam > sample.bam`

**-S**: specifies that the input file is a sam file
**-b**: species that we want to produce a bam file
**>**: denotes where to store the output bam file. 

```bash
nano $scripts/rhino_bam_coverage.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_sc_default
#SBATCH --job-name=rhino_bam_coverage
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"
markdup="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8/picard.jar"

# #sam to bam
# samtools view -S -b ~/scratch/BR18.sam > ~/scratch/BR18.bam

# #sort bam
# samtools sort ~/scratch/BR18.bam -T ~/scratch/BR18_temp.bam -o ~/scratch/BR18_sort.bam

#Mark Duplicates
java -Xmx100g -jar $markdup MarkDuplicates INPUT=~/scratch/BR18_sort.bam OUTPUT=~/scratch/BR18_sort_marked.bam METRICS_FILE=~/scratch/BR18_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index 
samtools index ~/scratch/BR18_sort_marked.bam ~/scratch/BR18_sort_marked.bai

#Calculate Coverage
samtools depth -a ~/scratch/BR18_sort_marked.bam >> ~/scratch/BR18_dp2.txt
awk '{sum+=$3} END {print sum/NR}' ~/scratch/BR18_dp2.txt >> ~/scratch/BR18_genomewide_coverage2.txt
```
