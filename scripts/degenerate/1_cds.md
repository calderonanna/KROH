# Codon Degeneracy 

## Install gffread
```bash
cd /storage/home/abc6435/SzpiechLab/bin
git clone https://github.com/gpertea/gffread
cd gffread
make release
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/gffread:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Obtain Exon Sequences
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/degen"
mywa="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference"

#extract Exons, sort, convert
gunzip -u $mywa/mywagenomev2.1.all.noseq.gff.gz
awk '$3=="exon"' $mywa/mywagenomev2.1.all.noseq.gff > $work/exons.gff
for i in `cat $scripts/autochrs.txt`; do 
    grep "^${i}\b" $work/exons.gff | sort -k4,4n >> $work/exons_sorted.gff;
done
gff2bed < $work/exons_sorted.gff > $work/exons_sorted.bed


#Extract exon sequences, with coordinates in FASTA header
bedtools getfasta \
    -fi $mywa/mywagenomev2.1.fa \
    -bed $work/exons_sorted.bed \
    -s -name -fo $work/exons.fa

#Modify Headers
sed -i 's/^>.::/>/' $work/exons.fa

#Format Sequences
awk 'NR % 2 == 0 {
         for(i=1;i<=length($0);i+=3) 
             print substr($0,i,3)
         next
     } 
     {print}' $work/exons.fa \
| awk 'BEGIN{n=1} 
       /^>/ {print; n=1; next} 
       {print $0"_"n*3; n++}' >> exons_counts.txt

#Export degenerate codons 
    #[GC][GCT].
awk '/^>/ {print; next}
    /^[GC][GCT]./ {print}' exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > GC_GCT_AGCT.temp

    #[AT]C.
awk '/^>/ {print; next}
    /^[AT]C./ {print}' exons_counts.txt \
| awk '/^>/ {header=$0; next} 
     {print header, $0}' > AT_C_AGCT.temp

#Format
sed -i 's/>//g' GC_GCT_AGCT.temp
sed -i 's/[:-]/\t/g' GC_GCT_AGCT.temp
sed -i 's/(/\t(/g' GC_GCT_AGCT.temp
sed -i 's/\s/\t/g' GC_GCT_AGCT.temp
sed -i 's/_/\t/g' GC_GCT_AGCT.temp


sed -i 's/>//g' AT_C_AGCT.temp
sed -i 's/[:-]/\t/g' AT_C_AGCT.temp
sed -i 's/(/\t(/g' AT_C_AGCT.temp
sed -i 's/\s/\t/g' AT_C_AGCT.temp
sed -i 's/_/\t/g' AT_C_AGCT.temp

awk '{print $1, $2+$6, $4, $5}' OFS="\t" GC_GCT_AGCT.temp >> 4fold.temp
awk '{print $1, $2+$6, $4, $5}' OFS="\t" OFS="\t" AT_C_AGCT.temp >> 4fold.temp