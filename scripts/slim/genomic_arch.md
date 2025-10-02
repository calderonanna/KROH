
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
cat $work/exon_chr29.txt $work/intron_chr29.txt $work/noncoding_chr29.txt >> $work/chr29.temp

sort -k2,2n -k3,3n $work/chr29.temp > $work/chr29_sorted.temp

#Remove Intron/Noncoding Redundancies 
awk '{
  lines[NR] = $0
  types[NR] = $1
}
END {
  for (i = 1; i <= NR; i++) {
    if (types[i] == "intron" && types[i+1] == "noncoding")
      continue
    print lines[i]
  }
}' $work/chr29_sorted.temp >> $work/chr29.txt

#File Clean Up
rm -rf *temp* *intron* *trans* *noncoding* *exon*

#Split

grep "exon" $work/chr29.txt | cut -f 2,3 > chr29_exons.txt
grep "intron" $work/chr29.txt | cut -f 2,3 > chr29_introns.txt
grep "noncoding" $work/chr29.txt | cut -f 2,3 > chr29_noncoding.txt

#Download
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/rxy/chr29_* /Users/annamariacalderon/Desktop/KROH/data/slim/rxy