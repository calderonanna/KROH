# Extract Genomic Structure

```bash
#Set Variable 
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gtf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"

for i in `cat $scripts/autochrs.txt`; do
  #Exons
  awk '$3=="exon" && $7=="+"' $gtf/mywagenomev2.1.gene_${i}.gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  #| uniq > $work/exon.txt

  #Intergenic 
  awk '$3=="transcript" && $7=="+"' $gtf/mywagenomev2.1.gene_${i}.gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  | uniq > $work/transcript_${i}.temp

  awk '
    NR==1 {
      start = 1
      end = $1 - 1
      if (start < end) print start "\t" end
    }
    NR>1 {
      start = prev + 1
      end = $1 - 1
      if (start < end) print start "\t" end
    }
    { prev = $2 }
  ' $work/transcript_${i}.temp > intergenic_${i}.txt
  rm -rf $work/transcript_${i}.temp

  #Include Last Exon to Chromosome End
  start=$(cat $work/exon_${i}.txt | tail -1 | cut -f2)
  end=$(grep "${i}\b" $work/chrlen.txt | cut -f2)
  echo -e "$((start+1))\t$end" >> $work/intergenic_${i}.txt
done
```
## Mutation Target Size
```bash
for i in `cat $scripts/autochrs_slim.txt`; do
  awk '{print $2-$1}' exon_${i}.txt | awk '{sum += $0} END {print sum}' >> $work/mutation_target_size.txt;
done

awk '{sum+= $0} END {print sum}' $work/mutation_target_size.txt