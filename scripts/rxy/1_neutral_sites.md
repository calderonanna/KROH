# Neutral Sites

## Intergenic
`bedtools instersect -v -a fileA -b fileB`
Report entries in A `.maf` that do not overlap any entry in B `transcript.gtf`
```bash
nano $scripts/intergenic.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=intergenic
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
rxy='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

for i in $(cat $scripts/autochrs.txt); do

    grep -E "^${i}\b" $maf/cKIWA_derived.maf | awk '{print $1, $2-1, $2}' OFS="\t" >> $rxy/KIWA_${i}.bed
    
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 > $rxy/${i}_genic.bed

    bedtools intersect -v -a $rxy/KIWA_${i}.bed -b $rxy/${i}_genic.bed >> $rxy/intergenic.bed;
done

#Reformat
echo "chromo    position" > $rxy/intergenic.txt
cut -f 1,3 $rxy/intergenic.bed >> $rxy/intergenic.txt
rm -rf $rxy/intergenic.bed
```

#Header 
head -1 $workdir/muts/lossoffunction.txt | cut -f 1,2 > $workdir/muts/intergenic.txt

cut -f 1,3 $workdir/muts/chKIWA_intergenic.bed >> $workdir/muts/intergenic.txt

rm -rf $workdir/muts/chKIWA_intergenic.bed

#Reformat File Headers
muts="deleterious lossoffunction nonsynonymous tolerated intergenic noncoding synonymous"

for i in $muts; do 
    cat $workdir/derived/hKIWA_derived.maf | head -1 | cut -f 1,2 >> $workdir/muts/${i}_mod.txt
    sed 1d $workdir/muts/${i}.txt | cut -f 1,2  >> $workdir/muts/${i}_mod.txt
    mv $workdir/muts/${i}.txt $workdir/muts/trash
    mv $workdir/muts/${i}_mod.txt $workdir/muts/${i}.txt;
done
```