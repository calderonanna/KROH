# Neutral Sites

## Intergenic
`bedtools instersect -v -a fileA -b fileB`
Report entries in A `.maf` that do not overlap any entry in B `transcript.gtf`
```bash
nano $scripts/intergenic.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=intergenic
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
rxy='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

for i in $(cat $scripts/autochrs.txt); do

    grep -E "^${i}\b" $maf/cKIWA_derived.maf | awk '{print $1, $2-1, $2}' OFS="\t" >> $rxy/KIWA_${i}.bed
    
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 > $rxy/${i}_genic.bed

    bedtools intersect -v -a $rxy/KIWA_${i}.bed -b $rxy/${i}_genic.bed >> $rxy/intergenic.bed
    
    rm -rf $rxy/KIWA_${i}.bed
    rm -rf $rxy/${i}_genic.bed;
done

#Reformat
echo "chromo    position" > $rxy/intergenic.txt
cut -f 1,3 $rxy/intergenic.bed >> $rxy/intergenic.txt
rm -rf $rxy/intergenic.bed
rm -rf $rxy/KIWA_*.bed
rm -rf $rxy/*genic.bed
```

## 4 Fold Synonymous Sites
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
rxy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
mywa="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#extract Exons, sort, convert, re-sort
awk '$3=="exon"' $mywa/mywagenomev2.1.all.noseq.gff > $rxy/exons.temp

for i in `cat $scripts/autochrs.txt`; do 
    grep "^${i}\b" $rxy/exons.temp | sort -k4,4n >> $rxy/exons.gff;
done

gff2bed < $rxy/exons.gff > $rxy/exons.bed

for i in `cat $scripts/autochrs.txt`; do 
    grep "^${i}\b" $rxy/exons.bed >> $rxy/exons_sorted.bed;
done

rm -rf $rxy/exons.bed
rm -rf $rxy/exons.temp
rm -rf $rxy/exons.gff

#Extract exon sequences, with coordinates in FASTA header
bedtools getfasta \
    -fi $mywa/mywagenomev2.1.fa \
    -bed $rxy/exons_sorted.bed \
    -s -name -fo $rxy/exons.fa

#Modify Headers
sed -i 's/^>.::/>/' $rxy/exons.fa

#Format Sequences
awk 'NR % 2 == 0 {
         for(i=1;i<=length($0);i+=3) 
             print substr($0,i,3)
         next
     } 
     {print}' $rxy/exons.fa \
| awk 'BEGIN{n=1} 
       /^>/ {print; n=1; next} 
       {print $0"@"n*3; n++}' >> $rxy/exons_counts.txt

#Export degenerate codons 
    #[GC][GCT].
awk '/^>/ {print; next}
    /^[GC][GCT]./ {print}' $rxy/exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > $rxy/GC_GCT_AGCT.temp

    #[AT]C.
awk '/^>/ {print; next}
    /^[AT]C./ {print}' $rxy/exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > $rxy/AT_C_AGCT.temp

#Format and filter
sed -i 's/>//g' $rxy/GC_GCT_AGCT.temp
sed -i 's/:/\t/g' $rxy/GC_GCT_AGCT.temp
sed -i 's/(/\t(/g' $rxy/GC_GCT_AGCT.temp
sed -i 's/\s/\t/g' $rxy/GC_GCT_AGCT.temp
sed -i 's/@/\t/g' $rxy/GC_GCT_AGCT.temp
sed -i 's/\([0-9]\)-\([0-9]\)/\1\t\2/g' $rxy/GC_GCT_AGCT.temp
sed -i 's/>//g' $rxy/AT_C_AGCT.temp
sed -i 's/:/\t/g' $rxy/AT_C_AGCT.temp
sed -i 's/(/\t(/g' $rxy/AT_C_AGCT.temp
sed -i 's/\s/\t/g' $rxy/AT_C_AGCT.temp
sed -i 's/@/\t/g' $rxy/AT_C_AGCT.temp
sed -i 's/\([0-9]\)-\([0-9]\)/\1\t\2/g' $rxy/AT_C_AGCT.temp

awk '{print $1, $2+$6, $4, $5}' OFS="\t" $rxy/GC_GCT_AGCT.temp >> $rxy/4fold.temp

awk '{print $1, $2+$6, $4, $5}' OFS="\t" OFS="\t" $rxy/AT_C_AGCT.temp >> $rxy/4fold.temp

awk 'length($4) == 3 && $4 !~ /[a-zN]/' $rxy/4fold.temp >> $rxy/4fold.temp2

echo "chromo    position" >> $rxy/4fold.txt
for i in `cat $scripts/autochrs.txt`; do 
    grep -E "${i}\b" $rxy/4fold.temp2 | sort -k2,2n | cut -f 1,2 >> $rxy/4fold.txt;
done

#remove any repetitive sites
grep -v -f $rxy/synonymous.txt $rxy/4fold.txt >> $rxy/4fold_synonymous.txt


#Clean Up Files
rm -rf $rxy/AT_C_AGCT.temp
rm -rf $rxy/4fold.temp*
rm -rf $rxy/GC_GCT_AGCT.temp
rm -rf $rxy/exons.fa
rm -rf $rxy/exons_counts.txt
rm -rf $rxy/exons_sorted.bed 
rm -rf $rxy/4fold.txt
```