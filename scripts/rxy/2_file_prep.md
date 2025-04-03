# File Preperation

## Install Rxy-kin
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

#Git Clone
cd $bin
git clone https://github.com/szpiech/Rxy-kin.git

#Add it to PATH
echo 'export PATH=$PATH:/storage/home/abc6435/SzpiechLab/bin/Rxy-kin/Rxy-kin.py' >> ~/.bashrc
source ~/.bashrc
```

## Obtain Private
We defined private sites as those in which at least one sample in a single species had an alternate allele, while the rest contained reference alleles. 

`./get_only_private_alt_alleles your.vcf.gz pop_ids.txt`
-`vcf`: Must be zipped
-`pop_ids`: a text file with species sample names on each row 
```bash

#filter out any missing sites
bcftools view -i 'N_MISSING<1' $data/vcf/$vcf -Oz -o $data/rxy/nomissing.vcf.gz 
bcftools annotate -x INFO,FORMAT $data/rxy/nomissing.vcf.gz -Oz -o $data/rxy/nomissing_gt.vcf.gz

#Obtain private allele sites
./get_only_private_alt.py ~/SzpiechLab/abc6435/WarblerROH/vcf/Setophaga/setophaga_filtered_isec_nomono.vcf.gz /storage/home/abc6435/SzpiechLab/abc6435/hWROH/scripts/cKIWA_IDS.txt

#Excess Heterozygosity (>80%)
bcftools view -e 'COUNT(GT="het")>=10' $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss.vcf.gz -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet.vcf.gz

#Remove Monomorphic Sites (would t
bcftools view $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto.vcf.gz -c 1:minor -Oz -o $work_dir/KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz


nohup tabix kirtlandii_private.vcf.gz
```

## Obtain Input Files
![alt text](../../diagrams/coordinate_systems.png)
```bash
#Set Variables
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#ID Files 
awk '{print $1, $2="A"}' OFS="\t" $scripts/cKIWA_IDS.txt > $data/pop_A.txt
awk '{print $1, $2="B"}' OFS="\t" $scripts/hKIWA_IDS.txt > $data/pop_B.txt

#Intergenic Sites
sed '1d' $data/rxy/deleterious.txt >> $data/rxy/genic_sites.bed
sed '1d' $data/rxy/tolerated.txt >> $data/rxy/genic_sites.bed
sed '1d' $data/rxy/synonymous.txt >> $data/rxy/genic_sites.bed
sed '1d' $data/rxy/nonsynonymous.txt >> $data/rxy/genic_sites.bed
sed '1d' $data/rxy/noncoding.txt >> $data/rxy/genic_sites.bed
sed '1d' $data/rxy/lossoffunction.txt >> $data/rxy/genic_sites.bed

awk '{print $1, $2-1, $2, $3}' OFS="\t" $data/rxy/genic_sites.bed > $data/rxy/temp && mv -f $data/rxy/temp $data/rxy/genic_sites.bed

zgrep ^"##contig=<ID=chr" nomissing_gt.vcf.gz | sed 's/##contig=<ID=//g' | sed 's/,.*//g' | sed '$d' > $data/rxy/chr.txt

for i in `cat $data/rxy/chr.txt`; do 
    grep -w "^${i}" $data/rxy/genic_sites.bed | sort -k3,3n  >> $data/rxy/genic_sites_sorted.bed; 
done

rm -rf $data/rxy/genic_sites.bed

awk '{print $1,$2,$3}' OFS="\t" $data/rxy/genic_sites_sorted.bed > $data/rxy/temp && mv -f $data/rxy/temp $data/rxy/genic_sites_sorted.bed

bcftools view -T ^$data/rxy/genic_sites_sorted.bed $data/rxy/nomissing_gt.vcf.gz -Oz -o $data/rxy/nomissing_gt_intergenic.vcf.gz

#Randomly Sample 2 sets of 100K intergenic sites.
bcftools view -H $data/rxy/nomissing_gt_intergenic.vcf.gz | shuf -n 100000 | cut -f1,2 > intergenic_v1.txt
for i in `cat $data/rxy/chr.txt`; do 
    grep -w "^${i}" $data/rxy/intergenic_v1.txt | sort -k2,2n  >> $data/rxy/intergenic_v1_sorted.txt;
done
rm -rf $data/rxy/intergenic_v1.txt

bcftools view -H $data/rxy/nomissing_gt_intergenic.vcf.gz | shuf -n 100000 | cut -f1,2 > intergenic_v2.txt
for i in `cat $data/rxy/chr.txt`; do 
    grep -w "^${i}" $data/rxy/intergenic_v2.txt | sort -k2,2n  >> $data/rxy/intergenic_v2_sorted.txt;
done
rm -rf $data/rxy/intergenic_v2.txt

#drop last column from mutation files
awk '{print $1,$2}' OFS="\t" $data/rxy/deleterious.txt > $data/rxy/del.txt
awk '{print $1,$2}' OFS="\t" $data/rxy/tolerated.txt > $data/rxy/tol.txt
awk '{print $1,$2}' OFS="\t" $data/rxy/lossoffunction.txt > $data/rxy/lof.txt
awk '{print $1,$2}' OFS="\t" $data/rxy/nonsynonymous.txt > $data/rxy/nonsyn.txt
awk '{print $1,$2}' OFS="\t" $data/rxy/synonymous.txt > $data/rxy/syn.txt
awk '{print $1,$2}' OFS="\t" $data/rxy/noncoding.txt > $data/rxy/noncode.txt
```
