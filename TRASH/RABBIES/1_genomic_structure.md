# Genomic Structure

## Obtain Exons
```bash
#Set Variables
gtf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

for i in $(cat $scripts/autochrs.txt); do
  awk '$3=="exon" && $7=="+"' $gtf/mywagenomev2.1.gene_${i}.gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  | uniq > $work/exon_${i}.txt
done



