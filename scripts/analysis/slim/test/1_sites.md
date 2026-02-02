## Obtain Intergenic Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/test"

#Intergenic Sites
awk '{print "20", $0}' OFS="\t" $data/slim/genome_structure/intergenic_chr20.txt > $work/intergenic_chr20.bed 
echo -e "chromo\tposition" > $work/intergenic20.txt 
bcftools view -R $work/intergenic_chr20.bed $work/rec_test.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic20.txt 
rm -rf $work/intergenic_chr20.bed 
```

## Obtain Genic Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/test"

#Genic Sites
awk '{print "20", $0}' OFS="\t" $data/slim/genome_structure/exon_chr20.txt > $work/exon_chr20.bed 
```

## Partition Mutation Sites
```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/test"

#S=0 
echo -e "chromo\tposition" > $work/neutral20.txt 
bcftools view \
  -R $work/exon_chr20.bed \
  -i 'INFO/S=0' \
  -H \
  $work/rec_test.vcf.gz | cut -f1,2 >> $work/neutral20.txt

#-0.05 < S < 0 (mild)
echo -e "chromo\tposition" > $work/mild20.txt 
bcftools view \
  -R $work/exon_chr20.bed \
  -i 'INFO/S>-0.05 && INFO/S<0' \
  -H \
  $work/rec_test.vcf.gz | cut -f1,2 >> $work/mild20.txt

#-0.10 < S < -0.05 (moderate)
echo -e "chromo\tposition" > $work/moderate20.txt 
bcftools view \
  -R $work/exon_chr20.bed \
  -i 'INFO/S>-0.10 && INFO/S<-0.05' \
  -H \
  $work/rec_test.vcf.gz | cut -f1,2 >> $work/moderate20.txt

#S < -0.10 (strong)
echo -e "chromo\tposition" > $work/strong20.txt 
bcftools view \
  -R $work/exon_chr20.bed \
  -i 'INFO/S<-0.10' \
  -H \
  $work/rec_test.vcf.gz | cut -f1,2 >> $work/strong20.txt

rm -rf $work/exon_chr20.bed 

