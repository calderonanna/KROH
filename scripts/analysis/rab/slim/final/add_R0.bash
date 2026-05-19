nano $scripts/add_R0.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=5GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic
#SBATCH --job-name=add_R0
#SBATCH --error=/storage/group/zps5164/default/abc6435/KROH/err/%x.%j.out

#Set Variables
results="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/results"
slim="/storage/group/zps5164/default/bin/SLiM/build/slim"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
data="/storage/group/zps5164/default/abc6435/KROH/data"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/add/R0"
seed_value=$(shuf -i 1-10000 -n 1)

#Create replicate folder
mkdir $work
mkdir $work/eggs

#Copy/modify slim script
cp $scripts/add.slim $scripts/add_R0.slim
sed -i "s/add\//add\/R0\//g" $scripts/add_R0.slim

#Run SLiM script
$slim -p $scripts/add_R0.slim

# Reheader Sample Names
bcftools reheader --samples $scripts/hKIWA_slim_IDS.txt $work/hKIWA_add.vcf -o $work/hKIWA_add_reheadered.vcf
bcftools reheader --samples $scripts/cKIWA_slim_IDS.txt $work/cKIWA_add.vcf -o $work/cKIWA_add_reheadered.vcf
#bcftools reheader --samples $scripts/hKIWA_IDS_e759877.txt $work/hKIWA_add.vcf -o $work/hKIWA_add_reheadered.vcf
#bcftools reheader --samples $scripts/cKIWA_IDS.txt $work/cKIWA_add.vcf -o $work/cKIWA_add_reheadered.vcf

#Merge VCFs
bgzip $work/hKIWA_add_reheadered.vcf
bgzip $work/cKIWA_add_reheadered.vcf
bcftools index $work/hKIWA_add_reheadered.vcf.gz
bcftools index $work/cKIWA_add_reheadered.vcf.gz
bcftools merge $work/hKIWA_add_reheadered.vcf.gz $work/cKIWA_add_reheadered.vcf.gz -Oz -o $work/add.vcf.gz
bcftools index $work/add.vcf.gz
rm -rf $work/*KIWA*

#Obtain Intergenic Sites
for i in `cat $scripts/autochrs_slim.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/add.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 

#Obtain Genic Sites
for i in `cat $scripts/autochrs_slim.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chr//g' $work/exon.bed

## Partition Mutations
# Neutral
echo -e "chromo\tposition" > $work/neutral.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S==0' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/neutral.txt

# Nearly Neutral
echo -e "chromo\tposition" > $work/nearlyneutral.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.0001 && INFO/S<0' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/nearlyneutral.txt

# Weak
echo -e "chromo\tposition" > $work/weak.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<=-0.0001 && INFO/S>-0.001' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/weak.txt

# Mild
echo -e "chromo\tposition" > $work/mild.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<=-0.001 && INFO/S>-0.01' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/mild.txt

# Moderate
echo -e "chromo\tposition" > $work/moderate.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.1 && INFO/S<=-0.01' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/moderate.txt

# Strong
echo -e "chromo\tposition" > $work/strong.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<-0.1' \
  -H \
  $work/add.vcf.gz | cut -f1,2 >> $work/strong.txt

rm -rf $work/exon.bed 

#Calculate RAB
source ~/RABvcfs_env/bin/activate
bgzip -d $work/add.vcf.gz
rm -rf $work/add.vcf.gz.csi

#Run RABmafs
muts="neutral nearlyneutral weak mild moderate strong"
for mut in $muts; do
    echo ${mut} >> $work/intergenic_rab.txt
    python3 $scripts/RABvcfs.py \
    --vcf $work/add.vcf \
    --pop $scripts/slim_pops.txt \
    --fileN $work/intergenic.txt \
    --fileM $work/${mut}.txt \
    --seed $seed_value \
    --psites 0.30 \
    --iter 1 \
    --simulated_vcf >> $work/intergenic_rab.txt
done

#Move VCF for EGGS 
mv $work/add.vcf $work/eggs

#Compile RAB Results
echo -e "neutral\nnearlyneutral\nweak\nmild\nmoderate\nstrong" >> $work/mut.temp
grep "N_Sites =  " $work/intergenic_rab.txt\
  | sed "s/N_Sites =  //g" >> $work/count.temp
grep "RAB = " $work/intergenic_rab.txt\
  | sed "s/RAB = //g" >> $work/rab.temp
grep "RAB_neutral =" $work/intergenic_rab.txt \
  | sed "s/RAB_neutral =  //g" >> $work/rab_neu.temp
grep "PopA Homozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopA Homozygotes =  //g" >> $work/A_hom.temp
grep "PopA Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopA Heterozygotes =  //g" >> $work/A_het.temp
grep "PopB Homozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopB Homozygotes =  //g" >> $work/B_hom.temp
grep "PopB Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopB Heterozygotes =  //g" >> $work/B_het.temp
yes "0.5" | head -n6 >> $work/h.temp
yes "R0" | head -n6 >> $work/rep.temp

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
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/R0/eggs"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/R0/eggs"

#Split VCF by Sample
bcftools view -S $scripts/cKIWA_slim_IDS.txt $sim_vcf/add.vcf -o $sim_vcf/add_cKIWA.vcf
bcftools view -S $scripts/hKIWA_slim_IDS.txt $sim_vcf/add.vcf -o $sim_vcf/add_hKIWA.vcf
#bcftools view -S $scripts/cKIWA_IDS.txt $sim_vcf/add.vcf -o $sim_vcf/add_cKIWA.vcf
#bcftools view -S $scripts/hKIWA_IDS_e759877.txt $sim_vcf/add.vcf -o $sim_vcf/add_hKIWA.vcf
bgzip $sim_vcf/add_cKIWA.vcf
bgzip $sim_vcf/add_hKIWA.vcf

#Run Eggs
$eggs \
-b $emp_vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_cKIWA.vcf.gz \
-d 0.712462,0.05 -k \
< $sim_vcf/add_cKIWA.vcf.gz \
> $sim_vcf/add_cKIWA_eggs.vcf.gz

$eggs \
-b $emp_vcf/dSETO_auto_bi_qual_dp_KIWA_private_alternate_hKIWA.vcf.gz \
-d 0.712462,0.05 -k \
< $sim_vcf/add_hKIWA.vcf.gz \
> $sim_vcf/add_hKIWA_eggs.vcf.gz

#Merge VCFs
gunzip $sim_vcf/add_cKIWA_eggs.vcf.gz
bgzip $sim_vcf/add_cKIWA_eggs.vcf
bcftools index $sim_vcf/add_cKIWA_eggs.vcf.gz
gunzip $sim_vcf/add_hKIWA_eggs.vcf.gz
bgzip $sim_vcf/add_hKIWA_eggs.vcf
bcftools index $sim_vcf/add_hKIWA_eggs.vcf.gz
bcftools merge \
$sim_vcf/add_hKIWA_eggs.vcf.gz \
$sim_vcf/add_cKIWA_eggs.vcf.gz \
-Oz -o $sim_vcf/add_eggs.vcf.gz
bcftools index $sim_vcf/add_eggs.vcf.gz

#Obtain Intergenic Sites
for i in `cat $scripts/autochrs_slim.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/add_eggs.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 

#Obtain Genic Sites
for i in `cat $scripts/autochrs_slim.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chr//g' $work/exon.bed

## Partition Mutations
# Neutral
echo -e "chromo\tposition" > $work/neutral.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S==0' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/neutral.txt

# Nearly Neutral
echo -e "chromo\tposition" > $work/nearlyneutral.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.0001 && INFO/S<0' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/nearlyneutral.txt

# Weak
echo -e "chromo\tposition" > $work/weak.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<=-0.0001 && INFO/S>-0.001' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/weak.txt

# Mild
echo -e "chromo\tposition" > $work/mild.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<=-0.001 && INFO/S>-0.01' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/mild.txt

# Moderate
echo -e "chromo\tposition" > $work/moderate.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.1 && INFO/S<=-0.01' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/moderate.txt

# Strong
echo -e "chromo\tposition" > $work/strong.txt
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<-0.1' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/strong.txt

rm -rf $work/exon.bed

#Calculate RAB
source ~/RABvcfs_env/bin/activate
bgzip -d $work/add_eggs.vcf.gz
rm -rf $work/add_eggs.vcf.gz.csi

#Run RABvcfs
muts="neutral nearlyneutral weak mild moderate strong"
for mut in $muts; do
    echo ${mut} >> $work/intergenic_rab.txt
    python3 $scripts/RABvcfs.py \
    --vcf $work/add_eggs.vcf \
    --pop $scripts/slim_pops.txt \
    --fileN $work/intergenic.txt \
    --fileM $work/${mut}.txt \
    --seed $seed_value \
    --psites 0.30 \
    --iter 1 \
    >> $work/intergenic_rab.txt
done

#Compile RAB Results
echo -e "neutral\nnearlyneutral\nweak\nmild\nmoderate\nstrong" >> $work/mut.temp
grep "N_Sites =  " $work/intergenic_rab.txt\
  | sed "s/N_Sites =  //g" >> $work/count.temp
grep "RAB = " $work/intergenic_rab.txt\
  | sed "s/RAB = //g" >> $work/rab.temp
grep "RAB_neutral =" $work/intergenic_rab.txt \
  | sed "s/RAB_neutral =  //g" >> $work/rab_neu.temp
grep "PopA Homozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopA Homozygotes =  //g" >> $work/A_hom.temp
grep "PopA Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopA Heterozygotes =  //g" >> $work/A_het.temp
grep "PopB Homozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopB Homozygotes =  //g" >> $work/B_hom.temp
grep "PopB Heterozygotes =  " $work/intergenic_rab.txt\
  | sed "s/PopB Heterozygotes =  //g" >> $work/B_het.temp
yes "0.5" | head -n6 >> $work/h.temp
yes "R0" | head -n6 >> $work/rep.temp

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
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/add/R0"
rm -rf $work
