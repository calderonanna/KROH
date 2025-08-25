# CDS

## Install gffread
```bash
cd /storage/home/abc6435/SzpiechLab/bin
git clone https://github.com/gpertea/gffread
cd gffread
make release
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/gffread:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Obtain coding sequences
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/degen"
mywa="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference"

#extract Exons
gunzip -u $mywa/mywagenomev2.1.all.noseq.gff.gz

# Extract only exons
awk '$3=="exon"' $mywa/mywagenomev2.1.all.noseq.gff > $work/exons.gff

# Convert to BED


# Extract exon sequences, with coordinates in FASTA header
bedtools getfasta -fi $mywa/mywagenomev2.1.fa -bed exons.gff -s -name

