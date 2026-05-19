# SLiM Test
## RUN
```bash
nano $scripts/dom_test14.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=5GB
#SBATCH --time=360:00:00
#SBATCH --account=zps5164_sc_default

for i in {1..50}; do

  #Set Variables
  test="test14"
  slim="/storage/group/zps5164/default/bin/SLiM/build/slim"
  gtf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
  work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/$test"
  scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
  chr="chr2"
  id="2"
  length="150066519"
  RecRate="3e-9"
  beta="-0.0097"
  alpha="0.22"
  seed_value=$(shuf -i 1-10000 -n 1)

  #FILE CLEAN UP
  cd $work
  rm -rf *vcf* *txt* *chr* *tmp*

  ##GENOMIC STRUCTURE
  #Exons
  awk '$3=="exon" && $7=="+"' $gtf/mywagenomev2.1.gene_$chr.gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  | uniq > $work/exon.txt

  #Intergenic 
  awk '$3=="transcript" && $7=="+"' $gtf/mywagenomev2.1.gene_$chr.gtf \
  | awk '{print $4"\t"$5}' \
  | sort -k1,1n -k2,2n \
  | uniq > $work/transcript.temp

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
  ' $work/transcript.temp > intergenic.txt
  rm -rf $work/transcript.temp

  #RUN SIMULATION
  cp $work/../dom.slim $work/dom_$chr.slim
  sed -i "s/RecRate/$RecRate/g" $work/dom_$chr.slim
  sed -i "s/beta/$beta/g" $work/dom_$chr.slim
  sed -i "s/alpha/$alpha/g" $work/dom_$chr.slim
  sed -i "s/chr/$id/g" $work/dom_$chr.slim
  sed -i "s/lng/$length/g" $work/dom_$chr.slim
  sed -i "s/test/$test/g" $work/dom_$chr.slim
  $slim -p $work/dom_$chr.slim

  ##DATA WRANGLING
  # Reheader Sample Names
  bcftools reheader --samples $scripts/hKIWA_IDS_e759877.txt $work/hKIWA_dom.vcf -o $work/hKIWA_dom_reheadered.vcf
  bcftools reheader --samples $scripts/cKIWA_IDS.txt $work/cKIWA_dom.vcf -o $work/cKIWA_dom_reheadered.vcf

  #Merge VCFs
  bgzip $work/hKIWA_dom_reheadered.vcf
  bgzip $work/cKIWA_dom_reheadered.vcf
  bcftools index $work/hKIWA_dom_reheadered.vcf.gz
  bcftools index $work/cKIWA_dom_reheadered.vcf.gz  
  bcftools merge $work/hKIWA_dom_reheadered.vcf.gz $work/cKIWA_dom_reheadered.vcf.gz -Oz -o $work/dom.vcf.gz
  bcftools index $work/dom.vcf.gz
  rm -rf *KIWA*

  #Intergenic Sites
  awk -v chr=$chr '{print chr, $0}' OFS="\t" $work/intergenic.txt >> $work/intergenic.bed
  sed -i 's/chr//g' $work/intergenic.bed
  echo -e "chromo\tposition" > $work/intergenic.txt 
  bcftools view -R $work/intergenic.bed $work/dom.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
  rm -rf $work/intergenic.bed 

  #Exons
  awk -v chr=$chr '{print chr, $0}' OFS="\t" $work/exon.txt >> $work/exon.bed
  sed -i 's/chr//g' $work/exon.bed

  ##PARTITION MUTATIONS
  #S=0 
  echo -e "chromo\tposition" > $work/neutral.txt 
  bcftools view \
    -R $work/exon.bed \
    -i 'INFO/S=0' \
    -H \
    $work/dom.vcf.gz | cut -f1,2 >> $work/neutral.txt

  #-0.05 < S < 0 (mild)
  echo -e "chromo\tposition" > $work/mild.txt 
  bcftools view \
    -R $work/exon.bed \
    -i 'INFO/S>-0.05 && INFO/S<0' \
    -H \
    $work/dom.vcf.gz | cut -f1,2 >> $work/mild.txt

  #-0.10 < S < -0.05 (moderate)
  echo -e "chromo\tposition" > $work/moderate.txt 
  bcftools view \
    -R $work/exon.bed \
    -i 'INFO/S>-0.10 && INFO/S<-0.05' \
    -H \
    $work/dom.vcf.gz | cut -f1,2 >> $work/moderate.txt

  #S < -0.10 (strong)
  echo -e "chromo\tposition" > $work/strong.txt 
  bcftools view \
    -R $work/exon.bed \
    -i 'INFO/S<-0.10' \
    -H \
    $work/dom.vcf.gz | cut -f1,2 >> $work/strong.txt

  rm -rf $work/exon.bed 

  ##CALCULATE RAB
  #activate env
  source ~/RABvcfs_env/bin/activate

  #Unzip vcf file
  bgzip -d $work/dom.vcf.gz
  rm -rf $work/dom.vcf.gz.csi

  #Run RABmafs
  python3 $scripts/RABvcfs.py \
  --vcf $work/dom.vcf \
  --pop $scripts/pops.txt \
  --fileN $work/intergenic.txt \
  --fileM $work/neutral.txt \
  --seed $seed_value \
  --psites 0.30 \
  --iter 1 \
  --simulated_vcf > $work/neutral.tmp
  grep "RAB = " $work/neutral.tmp >> $work/NEURE

  python3 $scripts/RABvcfs.py \
  --vcf $work/dom.vcf \
  --pop $scripts/pops.txt \
  --fileN $work/intergenic.txt \
  --fileM $work/mild.txt \
  --seed $seed_value \
  --psites 0.30 \
  --iter 1 \
  --simulated_vcf > $work/mild.tmp
  grep "RAB = " $work/mild.tmp >> $work/MILDRE

  python3 $scripts/RABvcfs.py \
  --vcf $work/dom.vcf \
  --pop $scripts/pops.txt \
  --fileN $work/intergenic.txt \
  --fileM $work/moderate.txt \
  --seed $seed_value \
  --psites 0.30 \
  --iter 1 \
  --simulated_vcf > $work/moderate.tmp
  grep "RAB = " $work/moderate.tmp >> $work/MODRE

  python3 $scripts/RABvcfs.py \
  --vcf $work/dom.vcf \
  --pop $scripts/pops.txt \
  --fileN $work/intergenic.txt \
  --fileM $work/strong.txt \
  --seed $seed_value \
  --psites 0.30 \
  --iter 1 \
  --simulated_vcf > $work/strong.tmp
  grep "RAB = " $work/strong.tmp >> $work/STRRE;

done

cd $work
rm -rf *vcf* *txt* *chr* *tmp*