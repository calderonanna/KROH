# Simulate Missing Data
https://github.com/TQ-Smith/EGGS
eggs -b empirical.vcf.gz -d 0.7,0.05 < simulated.vcf.gz > simulated_missing.vcf.gz

- -d, --deamin:Two comma-seperated proportions "prob1,prob2" where prob1 is the probability the site is a transition and prob2 is the probability of deamination. ts/ts+tv

```bash
#Re-Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/eggs"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/eggs"

#Split VCF by Sample
bcftools view -S $scripts/cKIWA_IDS.txt $sim_vcf/add.vcf -o $sim_vcf/add_cKIWA.vcf
bcftools view -S $scripts/hKIWA_IDS_e759877.txt $sim_vcf/add.vcf -o $sim_vcf/add_hKIWA.vcf
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
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/intergenic_${i}.txt >> $work/intergenic.bed
done
sed -i 's/chr1a/chr100/g' $work/intergenic.bed
sed -i 's/chr4a/chr400/g' $work/intergenic.bed
sed -i 's/chr//g' $work/intergenic.bed
echo -e "chromo\tposition" > $work/intergenic.txt 
bcftools view -R $work/intergenic.bed $work/add_eggs.vcf.gz | grep -v ^# | cut -f1,2 >> $work/intergenic.txt 
rm -rf $work/intergenic.bed 

#Obtain Genic Sites
for i in `cat $scripts/autochrs.txt`; do
    awk -v chr="${i}" '{print chr, $0}' OFS="\t" $data/slim/genome_structure/exon_${i}.txt >> $work/exon.bed
done
sed -i 's/chr1a/chr100/g' $work/exon.bed
sed -i 's/chr4a/chr400/g' $work/exon.bed
sed -i 's/chr//g' $work/exon.bed


# Partition Mutation Sites
#S=0 
echo -e "chromo\tposition" > $work/neutral.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S=0' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/neutral.txt

#-0.05 < S < 0 (mild)
echo -e "chromo\tposition" > $work/mild.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.05 && INFO/S<0' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/mild.txt

#-0.10 < S < -0.05 (moderate)
echo -e "chromo\tposition" > $work/moderate.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S>-0.10 && INFO/S<-0.05' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/moderate.txt

#S < -0.10 (strong)
echo -e "chromo\tposition" > $work/strong.txt 
bcftools view \
  -R $work/exon.bed \
  -i 'INFO/S<-0.10' \
  -H \
  $work/add_eggs.vcf.gz | cut -f1,2 >> $work/strong.txt
rm -rf $work/exon.bed 



nano $scripts/add_eggs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=200:00:00
#SBATCH --account=open
#SBATCH --partition=himem
#SBATCH --job-name=add_eggs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Re-Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
emp_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"
sim_vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/eggs"
eggs="/storage/home/abc6435/SzpiechLab/bin/EGGS/bin/eggs"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/add/eggs"

#Re-calculate RAB
source ~/RABvcfs_env/bin/activate
bgzip -d $work/add_eggs.vcf.gz
rm -rf $work/add_eggs.vcf.gz.csi

#Re-run RABvcfs
muts="neutral mild moderate strong"
for mut in $muts; do
    echo ${mut} >> $work/intergenic_rab.txt
    python3 $scripts/RABvcfs.py \
    --vcf $work/add_eggs.vcf \
    --pop $scripts/pops.txt \
    --fileN $work/intergenic.txt \
    --fileM $work/${mut}.txt \
    --seed $seed_value \
    --psites 0.30 \
    --iter 1 \
    >> $work/intergenic_rab.txt
done

#Compile Results
echo -e "neutral\nmild\nmoderate\nstrong" >> $work/mut.temp
grep "Number of derived mutations =" $work/intergenic_rab.txt\
  | sed "s/Number of derived mutations = //g" >> $work/count.temp
grep "RAB = " $work/intergenic_rab.txt\
  | sed "s/RAB = //g" >> $work/rab.temp
yes "0.5" | head -n4 >> $work/h.temp
paste $work/mut.temp $work/count.temp $work/rab.temp $work/h.temp >> $work/add.results
rm -rf $work/*temp* $work/*txt*