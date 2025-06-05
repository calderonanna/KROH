# Intergenic Sites
![alt text](../../diagrams/coordinate_systems.png)

```bash
#Set Variables
vcf="KIWA_dowsampled_tags_auto_bi_private_nmiss.vcf.gz"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Concatenate all genic sites
sed '1d' $work_dir/deleterious.txt >> $work_dir/genic_sites.bed
sed '1d' $work_dir/tolerated.txt >> $work_dir/genic_sites.bed
sed '1d' $work_dir/synonymous.txt >> $work_dir/genic_sites.bed
sed '1d' $work_dir/nonsynonymous.txt >> $work_dir/genic_sites.bed
sed '1d' $work_dir/noncoding.txt >> $work_dir/genic_sites.bed
sed '1d' $work_dir/lossoffunction.txt >> $work_dir/genic_sites.bed

#Format .bed
awk '{print $1, $2-1, $2, $3}' OFS="\t" $work_dir/genic_sites.bed \
    > $work_dir/temp && mv -f $work_dir/temp $work_dir/genic_sites.bed

#Sort genic genic_sites.bed
zgrep ^"##contig=<ID=chr" $work_dir/$vcf \
    | sed 's/##contig=<ID=//g' \
    | sed 's/,.*//g' \
    | sed '$d' > $work_dir/chr.txt

for i in `cat $work_dir/chr.txt`; do 
    grep -w "^${i}" $work_dir/genic_sites.bed \
    | sort -k3,3n  \
    >> $work_dir/genic_sites_sorted.bed; 
done

#File Clean Up
rm -rf $work_dir/genic_sites.bed
mv -f $work_dir/genic_sites_sorted.bed $work_dir/genic_sites.bed

#Drop mutation column 
awk '{print $1,$2,$3}' OFS="\t" $work_dir/genic_sites.bed \
    > $work_dir/temp && mv -f $work_dir/temp $work_dir/genic_sites.bed

# Extract Intergenic Sites (genic sites - VCF = intergenic)
bcftools view -T ^$work_dir/genic_sites.bed \
    $work_dir/$vcf \
    -Oz -o $work_dir/intergenic_downsampled.vcf.gz
```

## Sample Intergenic Sites
```bash
#Set Variables
vcf="intergenic_downsampled.vcf.gz"

#Extract Set 1 and Sort
bcftools view -H $work_dir/$vcf \
    | shuf -n 10000 \
    | cut -f1,2 > $work_dir/intergenic_downsampled_1.txt

for i in `cat $work_dir/chr.txt`; do 
    grep -w "^${i}" $work_dir/intergenic_downsampled_1.txt \
        | sort -k2,2n  \
        >> $work_dir/temp1.txt;
done

rm -rf $work_dir/intergenic_downsampled_1.txt
mv -f $work_dir/temp1.txt $work_dir/interdown1.txt

#Extract Set 2 and Sort
bcftools view -H $work_dir/$vcf \
    | shuf -n 10000 \
    | cut -f1,2 > $work_dir/intergenic_downsampled_2.txt

for i in `cat $work_dir/chr.txt`; do 
    grep -w "^${i}" $work_dir/intergenic_downsampled_2.txt \
        | sort -k2,2n  \
        >> $work_dir/temp2.txt;
done

rm -rf $work_dir/intergenic_downsampled_2.txt
mv -f $work_dir/temp2.txt $work_dir/interdown2.txt
```

## Clean Up Mutation Files
```bash
#drop last column from mutation files
awk '{print $1,$2}' OFS="\t" $work_dir/deleterious.txt > $work_dir/del.txt
awk '{print $1,$2}' OFS="\t" $work_dir/tolerated.txt > $work_dir/tol.txt
awk '{print $1,$2}' OFS="\t" $work_dir/lossoffunction.txt > $work_dir/lof.txt
awk '{print $1,$2}' OFS="\t" $work_dir/nonsynonymous.txt > $work_dir/nonsyn.txt
awk '{print $1,$2}' OFS="\t" $work_dir/synonymous.txt > $work_dir/syn.txt
awk '{print $1,$2}' OFS="\t" $work_dir/noncoding.txt > $work_dir/noncode.txt

rm -rf $work_dir/deleterious.txt $work_dir/tolerated.txt $work_dir/lossoffunction.txt $work_dir/nonsynonymous.txt $work_dir/synonymous.txt $work_dir/noncoding.txt
```
