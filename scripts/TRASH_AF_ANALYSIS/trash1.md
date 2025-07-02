# Intersection
Obtain the allele frequency intersection between cKIWA and hKIWA. In other words, subset the common sites. 

```bash
nano $scripts/intersect_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=intersect_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
work='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#zcat $work/cKIWA.mafs.gz | cut -f 1,2 >> $work/cKIWA_mafs.bed | less -S 
#awk '{print $1, $2-1, $2}' OFS="\t" $work/cKIWA_mafs.bed \
    #> $work/temp1 && mv -f $work/temp1 $work/cKIWA_mafs.bed
#sed -i 1d $work/cKIWA_mafs.bed

#zcat $work/hKIWA.mafs.gz | cut -f 1,2 >> $work/hKIWA_mafs.bed | less -S 
#awk '{print $1, $2-1, $2}' OFS="\t" $work/hKIWA_mafs.bed \
    #> $work/temp2 && mv -f $work/temp2 $work/hKIWA_mafs.bed
#sed -i 1d $work/hKIWA_mafs.bed

#Split bed files by chr
# for i in `cat $scripts/autochrs.txt`; do 
#     grep -E "^${i}\b" $work/cKIWA_mafs.bed >> $work/cKIWA_mafs_${i}.bed;
# done

# for i in `cat $scripts/autochrs.txt`; do 
#     grep -E "^${i}\b" $work/hKIWA_mafs.bed >> $work/hKIWA_mafs_${i}.bed;
# done

#Intersect
for i in `cat $scripts/autochrs.txt`; do 
    bedtools intersect -a $work/cKIWA_mafs_${i}.bed -b $work/hKIWA_mafs_${i}.bed > $work/chKIWA_intersect_${i}.bed;
done

#concatenate
cat $work/chKIWA_intersect_chr1.bed $work/chKIWA_intersect_chr1a.bed $work/chKIWA_intersect_chr2.bed $work/chKIWA_intersect_chr3.bed $work/chKIWA_intersect_chr4.bed $work/chKIWA_intersect_chr4a.bed $work/chKIWA_intersect_chr5.bed $work/chKIWA_intersect_chr6.bed $work/chKIWA_intersect_chr7.bed $work/chKIWA_intersect_chr8.bed $work/chKIWA_intersect_chr9.bed $work/chKIWA_intersect_chr10.bed $work/chKIWA_intersect_chr11.bed $work/chKIWA_intersect_chr12.bed $work/chKIWA_intersect_chr13.bed $work/chKIWA_intersect_chr14.bed $work/chKIWA_intersect_chr15.bed $work/chKIWA_intersect_chr17.bed $work/chKIWA_intersect_chr18.bed $work/chKIWA_intersect_chr19.bed $work/chKIWA_intersect_chr20.bed $work/chKIWA_intersect_chr21.bed $work/chKIWA_intersect_chr22.bed $work/chKIWA_intersect_chr23.bed $work/chKIWA_intersect_chr24.bed $work/chKIWA_intersect_chr25.bed $work/chKIWA_intersect_chr26.bed $work/chKIWA_intersect_chr27.bed $work/chKIWA_intersect_chr28.bed $work/chKIWA_intersect_chr29.bed >> $work/chKIWA_intersected.bed

#File Clean up 
for i in `cat $scripts/autochrs.txt`; do 
    rm -rf $work/chKIWA_intersect_${i}.bed
    rm -rf $work/cKIWA_mafs_${i}.bed
    rm -rf $work/hKIWA_mafs_${i}.bed;
done

rm -rf $work/cKIWA_mafs.bed
rm -rf $work/hKIWA_mafs.bed
```