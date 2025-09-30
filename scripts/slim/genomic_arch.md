
```bash
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy"

#Non Coding
cat $annotations/mywagenomev2.1.gene_chr29.gtf \
    | cut -f3,4,5 | grep "transcript" >> $work/transcript_chr29.txt

awk '{if(NR>1) print "noncoding", prev+1, $2-1; prev=$3}' \
    OFS="\t" $work/transcript_chr29.txt\
    >> $work/noncoding_chr29.txt

#Exons
cat $annotations/mywagenomev2.1.gene_chr29.gtf \
    | cut -f3,4,5 | grep "exon" >> $work/exon_chr29.txt

#Introns
awk '{if(NR>1) print "intron", prev+1, $2-1; prev=$3}' \
    OFS="\t" $work/exon_chr29.txt \
    >> $work/intron_chr29.txt

#concatenate and sort
cat $work/exon_chr29.txt $work/intron_chr29.txt $work/noncoding_chr29.txt >> $work/chr29_arch.temp

sort -n -k2,2n -k3,3n $work/chr29_arch.temp >> $work/chr29_arch.txt