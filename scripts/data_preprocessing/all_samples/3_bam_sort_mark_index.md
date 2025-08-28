# BAM Sort, Mark, and Index
`samtools view -S -b sample.sam > sample.bam`

**-S**: specifies that the input file is a sam file
**-b**: species that we want to produce a bam file
**>**: denotes where to store the output bam file. 

```bash
for i in `cat $scripts/SETO_IDS.txt`; do 
    cat <<EOT > $scripts/bam_sort_mark_index_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=10:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=bam_sort_mark_index_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
sam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sam"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
markdup="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8/picard.jar"
err="/storage/home/abc6435/SzpiechLab/abc6435/KROH/err"

#sam to bam
samtools view -S -b \$sam/${i}.sam > \$bam/${i}.bam

#sort bam
samtools sort \$bam/${i}.bam -T \$bam/${i}_temp.bam -o \$bam/${i}_sorted.bam

#mark
java -Xmx300g -jar \$markdup MarkDuplicates INPUT=\$bam/${i}_sorted.bam OUTPUT=\$bam/${i}_sorted_marked.bam METRICS_FILE=\$err/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index 
samtools index \$bam/${i}_sorted_marked.bam \$bam/${i}_sorted_marked.bai