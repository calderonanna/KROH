# Neutral Sites

## Intergenic
```bash
#Set Variables
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa.fai"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#genome.bed
awk '{print $1, 0, $2}' OFS="\t" $ref > $pixy/genome.tmp
grep -Ev "^(scaffold|mito|chrz)" $pixy/genome.tmp > $pixy/genome.bed

#genic.bed
for i in $(cat $scripts/autochrs.txt); do 
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 >> $pixy/genic.bed;
done

#intergenic.bed
bedtools subtract -a $pixy/genome.bed -b $pixy/genic.bed > $pixy/intergenic.bed

#file clean up
rm -rf $pixy/genome* $pixy/genic.bed
```


