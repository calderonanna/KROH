# Genomic Structure

## Obtain Exons
```bash
#Set Variables
gtf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit/mywagenomev2.1.gene_chr1.gtf"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure"

awk '$3=="exon" && $7=="+"' $gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  | uniq > $work/exon_chr1.txt


  #Download
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/genome_structure/exon_chr1.txt /Users/abc6435/Desktop/KROH/data/slim/genome_structure
```

