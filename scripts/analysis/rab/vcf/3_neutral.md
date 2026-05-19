# Neutral

## Intergenic
`bedtools instersect -v -a fileA -b fileB`
Report entries in A `.vcf` that do not overlap any entry in B `transcript.gtf`
```bash
salloc --nodes=1 --mem=100GB --time=8:00:00 --account=open --partition=himem

#Set Variables
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
rab='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rab/vcf'
vcf='/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate.vcf'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

for i in $(cat $scripts/autochrs.txt); do

    bcftools view -H $vcf | grep "^${i}\b" | awk '{print $1, $2-1, $2}' OFS="\t" >> $rab/KIWA_${i}.bed
    
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 > $rab/${i}_genic.bed

    bedtools intersect -v -a $rab/KIWA_${i}.bed -b $rab/${i}_genic.bed >> $rab/intergenic.bed
    
    rm -rf $rab/KIWA_${i}.bed
    rm -rf $rab/${i}_genic.bed;
done

#Reformat
echo -e "chromo\tposition" > $rab/intergenic.txt
cut -f 1,3 $rab/intergenic.bed >> $rab/intergenic.txt
rm -rf $rab/intergenic.bed
rm -rf $rab/KIWA_*.bed
rm -rf $rab/*genic.bed
```


## 4 Fold Synonymous Sites
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
rab="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rab/vcf"
mywa="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference"

#extract Exons, sort, convert, re-sort
awk '$3=="exon"' $mywa/mywagenomev2.1.all.noseq.gff > $rab/exons.temp

for i in `cat $scripts/autochrs.txt`; do 
    grep "^${i}\b" $rab/exons.temp | sort -k4,4n >> $rab/exons.gff;
done

gff2bed < $rab/exons.gff > $rab/exons.bed

for i in `cat $scripts/autochrs.txt`; do 
    grep "^${i}\b" $rab/exons.bed >> $rab/exons_sorted.bed;
done

rm -rf $rab/exons.bed
rm -rf $rab/exons.temp
rm -rf $rab/exons.gff

#Extract exon sequences, with coordinates in FASTA header
bedtools getfasta \
    -fi $mywa/mywagenomev2.1.fa \
    -bed $rab/exons_sorted.bed \
    -s -name -fo $rab/exons.fa

#Modify Headers
sed -i 's/^>.::/>/' $rab/exons.fa

#Format Sequences
awk 'NR % 2 == 0 {
         for(i=1;i<=length($0);i+=3) 
             print substr($0,i,3)
         next
     } 
     {print}' $rab/exons.fa \
| awk 'BEGIN{n=1} 
       /^>/ {print; n=1; next} 
       {print $0"@"n*3; n++}' >> $rab/exons_counts.txt

#Export degenerate codons 
    #[GC][GCT].
awk '/^>/ {print; next}
    /^[GC][GCT]./ {print}' $rab/exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > $rab/GC_GCT_AGCT.temp

    #[AT]C.
awk '/^>/ {print; next}
    /^[AT]C./ {print}' $rab/exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > $rab/AT_C_AGCT.temp

#Format and filter
sed -i 's/>//g' $rab/GC_GCT_AGCT.temp
sed -i 's/:/\t/g' $rab/GC_GCT_AGCT.temp
sed -i 's/(/\t(/g' $rab/GC_GCT_AGCT.temp
sed -i 's/\s/\t/g' $rab/GC_GCT_AGCT.temp
sed -i 's/@/\t/g' $rab/GC_GCT_AGCT.temp
sed -i 's/\([0-9]\)-\([0-9]\)/\1\t\2/g' $rab/GC_GCT_AGCT.temp
sed -i 's/>//g' $rab/AT_C_AGCT.temp
sed -i 's/:/\t/g' $rab/AT_C_AGCT.temp
sed -i 's/(/\t(/g' $rab/AT_C_AGCT.temp
sed -i 's/\s/\t/g' $rab/AT_C_AGCT.temp
sed -i 's/@/\t/g' $rab/AT_C_AGCT.temp
sed -i 's/\([0-9]\)-\([0-9]\)/\1\t\2/g' $rab/AT_C_AGCT.temp

awk '{print $1, $2+$6, $4, $5}' OFS="\t" $rab/GC_GCT_AGCT.temp >> $rab/4fold.temp

awk '{print $1, $2+$6, $4, $5}' OFS="\t" OFS="\t" $rab/AT_C_AGCT.temp >> $rab/4fold.temp

awk 'length($4) == 3 && $4 !~ /[a-zN]/' $rab/4fold.temp >> $rab/4fold.temp2

echo -e "chromo\tposition" >> $rab/4fold.txt
for i in `cat $scripts/autochrs.txt`; do 
    grep -E "${i}\b" $rab/4fold.temp2 | sort -k2,2n | cut -f 1,2 >> $rab/4fold.txt;
done

#remove any repetitive sites
echo -e "chromo\tposition" > $rab/4fold_synonymous.txt
grep -v -f $rab/synonymous.txt $rab/4fold.txt >> $rab/4fold_synonymous.txt


#Clean Up Files
rm -rf $rab/AT_C_AGCT.temp
rm -rf $rab/4fold.temp*
rm -rf $rab/GC_GCT_AGCT.temp
rm -rf $rab/exons.fa
rm -rf $rab/exons_counts.txt
rm -rf $rab/exons_sorted.bed 
rm -rf $rab/4fold.txt
```