# Run MapDamage
We only want to use the mitochondrial genome for this because 1. theres a ton of mitochondria and its sequenced at really high depth. 2. Mitochondria does not recombine so we can expect to get an unbiased estimation of degradation.  

## Subset Mitochondrial in BAM
You should NOT subset the reference. You can subset the bams using gatk or samtools. 

`gatk PrintReads --input in.bam -L chr1 --output out.bam`
`samtools view -b in.bam chr1 > chr1.bam`

```bash
salloc -N 1 -n 1 --account=open --mem=10GB -t 8:00:00

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference/mywagenomev2.1.fa"
samples="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts/KIWA_IDS.txt"

#Subset mito 
for i in `cat $samples`; do 
    samtools view -b $data/bam/${i}_marked.bam mito > $data/bam/${i}_mito.bam;
done 

#Run MapDamage
mapDamage -i $data/bam/183194841_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/183194861_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/183195304_mito.bam -r $ref --merge-libraries 

mapDamage -i $data/bam/183195312_mito.bam -r $ref --merge-libraries 

mapDamage -i $data/bam/183195321_mito.bam -r $ref --merge-libraries 

mapDamage -i $data/bam/183195326_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/183195332_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/29779_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/383194_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/383202_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/383205_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/507264_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/507265_mito.bam -r $ref --merge-libraries

mapDamage -i $data/bam/759877_mito.bam -r $ref --merge-libraries
```

## Download Plots
```bash
rsync abc6435@submit.hpc.psu.edu:~/SzpiechLab/abc6435/KROH/data/bam/183195304_mito.mapDamage/*pdf /Users/abc6435/Desktop
```