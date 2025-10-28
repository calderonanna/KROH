## Something Wrong vvv
```bash
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure"

#Non Coding
cat $annotations/mywagenomev2.1.gene_chr1.gtf \
    | cut -f3,4,5 | grep "transcript" >> $work/transcript_chr1.txt

awk '{if(NR>1) print "noncoding", prev+1, $2-1; prev=$3}' \
    OFS="\t" $work/transcript_chr1.txt\
    >> $work/noncoding_chr1.txt
#Exons
cat $annotations/mywagenomev2.1.gene_chr1.gtf \
    | cut -f3,4,5 | grep "exon" >> $work/exon_chr1.txt

#Introns
awk '{if(NR>1) print "intron", prev+1, $2-1; prev=$3}' \
    OFS="\t" $work/exon_chr1.txt \
    >> $work/intron_chr1.txt

#concatenate and sort
cat $work/exon_chr1.txt $work/intron_chr1.txt $work/noncoding_chr1.txt >> $work/chr1.temp

sort -k2,2n -k3,3n $work/chr1.temp > $work/chr1_sorted.temp

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
}' $work/chr1_sorted.temp >> $work/chr1.txt

#File Clean Up
rm -rf *temp* *intron* *trans* *noncoding* *exon*

#Split
grep "exon" $work/chr1.txt | cut -f 2,3 > chr1_exons.txt
grep "intron" $work/chr1.txt | cut -f 2,3 > chr1_introns.txt
grep "noncoding" $work/chr1.txt | cut -f 2,3 > chr1_noncoding.txt

#Download
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure/exon_chr1.txt /Users/abc6435/Desktop/KROH/data/slim/genome_structure