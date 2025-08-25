# BAM
`samtools view -S -b sample.sam > sample.bam`

**-S**: specifies that the input file is a sam file
**-b**: species that we want to produce a bam file
**>**: denotes where to store the output bam file. 

```bash
nano $scripts/rhino_bam.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=rhino_align
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos"
work="/storage/group/zps5164/default/shared/rhinos"
markdup="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8/picard.jar"

#sam to bam
samtools view -S -b $work/sam/BR18.sam > $work/bam/BR18.bam

#sort bam
samtools sort $work/bam/BR18.bam -T $work/bam/BR18_temp.bam -o $work/bam/BR18_sort.bam

#mark
java -Xmx300g -jar $markdup MarkDuplicates INPUT=$work/bam/BR18_sort.bam OUTPUT=$work/bam/BR18_sort_mark.bam METRICS_FILE=$work/bam/BR18_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index 
samtools index $work/bam/BR18_sort_mark.bam $work/bam/BR18_sort_mark.bai
```
