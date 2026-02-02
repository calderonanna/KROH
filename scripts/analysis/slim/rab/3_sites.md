# Sites

## Obtain Intergenic Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf"

#Intergenic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done

sed -i 's/chr1a/chr100/g' $work/intergenic.bed
sed -i 's/chr4a/chr400/g' $work/intergenic.bed
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/rec.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 
```

## Obtain Genic Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf"

#Genic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chr1a/chr100/g' $work/exon.bed
sed -i 's/chr4a/chr400/g' $work/exon.bed
sed -i 's/chr//g' $work/exon.bed
```

## Partition Mutation Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf"

#S=0 
echo -e "chromo\tposition" > $work/neutral.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S=0' \
  -H \
  $work/rec.vcf.gz | cut -f1,2 >> $work/neutral.txt

#-0.05 < S < 0 (mild)
echo -e "chromo\tposition" > $work/mild.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.05 && INFO/S<0' \
  -H \
  $work/rec.vcf.gz | cut -f1,2 >> $work/mild.txt

#-0.10 < S < -0.05 (moderate)
echo -e "chromo\tposition" > $work/moderate.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.10 && INFO/S<-0.05' \
  -H \
  $work/rec.vcf.gz | cut -f1,2 >> $work/moderate.txt

#S < -0.10 (strong)
echo -e "chromo\tposition" > $work/strong.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<-0.10' \
  -H \
  $work/rec.vcf.gz | cut -f1,2 >> $work/strong.txt

rm -rf $work/exon.bed 

