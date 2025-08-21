# Mutations

## Upload Mutations
```bash
scp /Users/annamariacalderon/Desktop/KROH/data/rxy/* abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/muts
```

## Intergenic Sites 
```bash
nano $scripts/intergenic_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=intergenic_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
workdir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#Intergenic Sites: Excludes sites overlapping with genic regions. 
for i in `cat $scripts/autochrs.txt`; do
    cut -f 1,3-5 $annotations/mywagenomev2.1.gene_${i}.gtf | grep "transcript" | cut -f 1,3,4 > $workdir/muts/${i}_genic.bed

    zgrep -E "^${i}\b" $workdir/maf/chKIWA.mafs.gz | awk '{print $1, $2-1, $2}' OFS="\t" > $workdir/muts/chKIWA_${i}.bed

    bedtools intersect -v -a $workdir/muts/chKIWA_${i}.bed -b $workdir/muts/${i}_genic.bed >> $workdir/muts/chKIWA_intergenic.bed
    
    rm -rf $workdir/muts/chKIWA_${i}.bed
    rm -rf $workdir/muts/${i}_genic.bed;
done

#Add Header 
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