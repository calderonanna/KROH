# Neutral Sites

## Intergenic
```bash
#Set Variables
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa.fai"
pi="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pi"
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#genome.bed
awk '{print $1, 0, $2}' OFS="\t" $ref > $pi/genome.tmp
grep -Ev "^(scaffold|mito|chrz)" $pi/genome.tmp > $pi/genome.bed

#genic.bed
for i in $(cat $scripts/autochrs.txt); do 
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 >> $pi/genic.bed;
done

#intergenic.bed
bedtools subtract -a $pi/genome.bed -b $pi/genic.bed > $pi/intergenic.bed

#intergenic.txt
bedtools makewindows -b $pi/intergenic.bed -w 1 | sed 1d | cut -f1,2 > $pi/intergenic.txt

#file clean up
rm -rf $pi/genome.* $pi/*.bed
```


