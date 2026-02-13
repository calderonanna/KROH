nano $scripts/rec_R0.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=rec_R0
#SBATCH --error=/storage/group/zps5164/default/abc6435/KROH/err/%x.%j.out

#Set Variables
results="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/results"
slim="/storage/group/zps5164/default/bin/SLiM/build/slim"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
data="/storage/group/zps5164/default/abc6435/KROH/data"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/rec/R0"
seed_value=$(shuf -i 1-10000 -n 1)

#Create replicate directiory
mkdir $work
mkdir $work/eggs

#Copy/modify slim script
cp $scripts/rec.slim $scripts/rec_R0.slim
sed -i "s/rec\//rec\/R0\//g" $scripts/rec_R0.slim

#Run SLiM script
$slim -p $scripts/rec_R0.slim

# Reheader Sample Names
bcftools reheader --samples $scripts/hKIWA_IDS_e759877.txt $work/hKIWA_rec.vcf -o $work/hKIWA_rec_reheadered.vcf
bcftools reheader --samples $scripts/cKIWA_IDS.txt $work/cKIWA_rec.vcf -o $work/cKIWA_rec_reheadered.vcf

#Merge VCFs
bgzip $work/hKIWA_rec_reheadered.vcf
bgzip $work/cKIWA_rec_reheadered.vcf
bcftools index $work/hKIWA_rec_reheadered.vcf.gz
bcftools index $work/cKIWA_rec_reheadered.vcf.gz
bcftools merge $work/hKIWA_rec_reheadered.vcf.gz $work/cKIWA_rec_reheadered.vcf.gz -Oz -o $work/rec.vcf.gz
bcftools index $work/rec.vcf.gz
rm -rf $work/*KIWA*

#Obtain Intergenic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done
sed -i 's/chR0a/chR000/g' $work/intergenic.bed
sed -i 's/chr4a/chr400/g' $work/intergenic.bed
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/rec.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 

#Obtain Genic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chR0a/chR000/g' $work/exon.bed
sed -i 's/chr4a/chr400/g' $work/exon.bed
sed -i 's/chr//g' $work/exon.bed


# Partition Mutation Sites
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

#Calculate RAB
source ~/RABvcfs_env/bin/activate
bgzip -d $work/rec.vcf.gz
rm -rf $work/rec.vcf.gz.csi

#Run RABmafs
muts="neutral mild moderate strong"
for mut in $muts; do
    echo ${mut} >> $work/intergenic_rab.txt
    python3 $scripts/RABvcfs.py \
    --vcf $work/rec.vcf \
    --pop $scripts/pops.txt \
    --fileN $work/intergenic.txt \
    --fileM $work/${mut}.txt \
    --seed $seed_value \
    --psites 0.30 \
    --iter 1 \
    --simulated_vcf >> $work/intergenic_rab.txt
done

#Move VCF for EGGS 
mv $work/rec.vcf $work/eggs

#Compile RAB Results
echo -e "neutral\nmild\nmoderate\nstrong" >> $work/mut.temp
grep "N_Sites =  " $work/intergenic_rab.txt\
  | sed "s/N_Sites =  //g" >> $work/count.temp
grep "RAB = " $work/intergenic_rab.txt\
  | sed "s/RAB = //g" >> $work/rab.temp
grep -E 'RAB_neutral =' $work/intergenic_rab.txt \
  | sed 's/RAB_neutral =  //g' >> $work/rab_neu.temp
grep "PopA Homozygotes =  " $work/intergenic_rab.txt\
  | sed "PopA Homozygotes =  //g" >> $work/A_hom.temp
grep "PopA Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "PopA Heterozygotes =  //g" >> $work/A_het.temp
grep "PopB Homozygotes =  " $work/intergenic_rab.txt\
  | sed "PopB Homozygotes =  //g" >> $work/B_hom.temp
grep "PopB Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "PopB Heterozygotes =  //g" >> $work/B_het.temp
yes "0.0" | head -n4 >> $work/h.temp
yes "R0" | head -n4 >> $work/rep.temp

paste $work/mut.temp \
  $work/count.temp \
  $work/rab.temp \
  $work/rab_neu.temp \
  $work/A_hom.temp \
  $work/A_het.temp \
  $work/B_hom.temp \
  $work/B_het.temp \
  $work/h.temp \
  $work/rep.temp >> $results/results.txt

##################SIMULATE MISSING DATA#########################
#Re-Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/rec/R0/eggs"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/rec/R0/eggs"

#Split VCF by Sample
bcftools view -S $scripts/cKIWA_IDS.txt $sim_vcf/rec.vcf -o $sim_vcf/rec_cKIWA.vcf
bcftools view -S $scripts/hKIWA_IDS_e759877.txt $sim_vcf/rec.vcf -o $sim_vcf/rec_hKIWA.vcf
bgzip $sim_vcf/rec_cKIWA.vcf
bgzip $sim_vcf/rec_hKIWA.vcf

#Run Eggs
$eggs \
-b $emp_vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_cKIWA.vcf.gz \
-d 0.712462,0.05 -k \
< $sim_vcf/rec_cKIWA.vcf.gz \
> $sim_vcf/rec_cKIWA_eggs.vcf.gz

$eggs \
-b $emp_vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_hKIWA.vcf.gz \
-d 0.712462,0.05 -k \
< $sim_vcf/rec_hKIWA.vcf.gz \
> $sim_vcf/rec_hKIWA_eggs.vcf.gz

#Merge VCFs
gunzip $sim_vcf/rec_cKIWA_eggs.vcf.gz
bgzip $sim_vcf/rec_cKIWA_eggs.vcf
bcftools index $sim_vcf/rec_cKIWA_eggs.vcf.gz
gunzip $sim_vcf/rec_hKIWA_eggs.vcf.gz
bgzip $sim_vcf/rec_hKIWA_eggs.vcf
bcftools index $sim_vcf/rec_hKIWA_eggs.vcf.gz
bcftools merge \
$sim_vcf/rec_hKIWA_eggs.vcf.gz \
$sim_vcf/rec_cKIWA_eggs.vcf.gz \
-Oz -o $sim_vcf/rec_eggs.vcf.gz
bcftools index $sim_vcf/rec_eggs.vcf.gz

#Obtain Intergenic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done
sed -i 's/chR0a/chR000/g' $work/intergenic.bed
sed -i 's/chr4a/chr400/g' $work/intergenic.bed
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/rec_eggs.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 

#Obtain Genic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chR0a/chR000/g' $work/exon.bed
sed -i 's/chr4a/chr400/g' $work/exon.bed
sed -i 's/chr//g' $work/exon.bed

# Partition Mutation Sites
#S=0 
echo -e "chromo\tposition" > $work/neutral.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S=0' \
  -H \
  $work/rec_eggs.vcf.gz | cut -f1,2 >> $work/neutral.txt

#-0.05 < S < 0 (mild)
echo -e "chromo\tposition" > $work/mild.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.05 && INFO/S<0' \
  -H \
  $work/rec_eggs.vcf.gz | cut -f1,2 >> $work/mild.txt

#-0.10 < S < -0.05 (moderate)
echo -e "chromo\tposition" > $work/moderate.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.10 && INFO/S<-0.05' \
  -H \
  $work/rec_eggs.vcf.gz | cut -f1,2 >> $work/moderate.txt

#S < -0.10 (strong)
echo -e "chromo\tposition" > $work/strong.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<-0.10' \
  -H \
  $work/rec_eggs.vcf.gz | cut -f1,2 >> $work/strong.txt
rm -rf $work/exon.bed

#Calculate RAB
source ~/RABvcfs_env/bin/activate
bgzip -d $work/rec_eggs.vcf.gz
rm -rf $work/rec_eggs.vcf.gz.csi

#Run RABvcfs
muts="neutral mild moderate strong"
for mut in $muts; do
    echo ${mut} >> $work/intergenic_rab.txt
    python3 $scripts/RABvcfs.py \
    --vcf $work/rec_eggs.vcf \
    --pop $scripts/pops.txt \
    --fileN $work/intergenic.txt \
    --fileM $work/${mut}.txt \
    --seed $seed_value \
    --psites 0.30 \
    --iter 1 \
    >> $work/intergenic_rab.txt
done

#Compile RAB Results
echo -e "neutral\nmild\nmoderate\nstrong" >> $work/mut.temp
grep "N_Sites =  " $work/intergenic_rab.txt\
  | sed "s/N_Sites =  //g" >> $work/count.temp
grep "RAB = " $work/intergenic_rab.txt\
  | sed "s/RAB = //g" >> $work/rab.temp
grep -E 'RAB_neutral =' $work/intergenic_rab.txt \
  | sed 's/RAB_neutral =  //g' >> $work/rab_neu.temp
grep "PopA Homozygotes =  " $work/intergenic_rab.txt\
  | sed "PopA Homozygotes =  //g" >> $work/A_hom.temp
grep "PopA Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "PopA Heterozygotes =  //g" >> $work/A_het.temp
grep "PopB Homozygotes =  " $work/intergenic_rab.txt\
  | sed "PopB Homozygotes =  //g" >> $work/B_hom.temp
grep "PopB Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "PopB Heterozygotes =  //g" >> $work/B_het.temp
yes "0.0" | head -n4 >> $work/h.temp
yes "R0" | head -n4 >> $work/rep.temp

paste $work/mut.temp \
  $work/count.temp \
  $work/rab.temp \
  $work/rab_neu.temp \
  $work/A_hom.temp \
  $work/A_het.temp \
  $work/B_hom.temp \
  $work/B_het.temp \
  $work/h.temp \
  $work/rep.temp >> $results/results_eggs.txt

#Clean Up
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/rec/R0"
rm -rf $work
