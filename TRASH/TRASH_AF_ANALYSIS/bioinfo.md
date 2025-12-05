## Adapter Removal
```bash
#Remove Adapters
AdapterRemoval \
    --file1 $fastq/${i}_R1.fastq.gz \
    --file2 $fastq/${i}_R2.fastq.gz \
    --collapse \
    --trimns \
    --minlength 20 \
    --qualitybase 33 \
    --gzip \
    --basename $fastq/${i}_trimmed

#Align 
bowtie2 -p 4 --very-sensitive-local --local -N 0 --phred33 \
    -x $ref \
    --rg-id ${i} --rg SM:${i} -X 700 \\
    -1 $fastq/${i}_trimmed.pair1.truncated.gz \\
    -2 $fastq/${i}_trimmed.pair2.truncated.gz \\
    -U $fastq/${i}_trimmed.collapsed.gz \\
    -S $sam/${i}.sam \\
    >& $err/${i}_bowtie.log


#Sam to bam
samtools view -S -b $sam/${i}.sam > $bam/${i}.bam

#Sort bam
samtools sort $bam/${i}.bam -T $bam/${i}_temp.bam -o $bam/${i}_sorted.bam

#Mark Duplicates
java -Xmx65g -jar $markdup MarkDuplicates INPUT=$bam/${i}_sorted.bam OUTPUT=$bam/${i}_sorted_marked.bam METRICS_FILE=$err/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index 
samtools index $bam/${i}_sorted_marked.bam $bam/${i}_sorted_marked.bai

#Variant Calling
samples=$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf/*.g.vcf | sed 's/^/--variant /')

gatk HaplotypeCaller \
    -R ref.fa \
    -I $bam/${i}_sorted_marked.bam \
    -ERC GVCF \
    -O $gatk/gvcf/${i}.g.vcf \
    --native-pair-hmm-threads 2 \
    >& $gatk/log/${i}gvcf.log

gatk CombineGVCFs \
    $samples \
    -O $gatk/gvcf/combined.vcf \
    -R ref.fa \
    >& $gatk/log/combined.log

nohup bgzip $gatk/gvcf/combined.vcf
nohup tabix $gatk/gvcf/combined.vcf.gz

gatk --java-options "-Xmx100g" GenotypeGVCFs \
    -R ref.fa \
    -V $gatk/gvcf/combined.vcf.gz -O $gatk/vcf/final.vcf.gz