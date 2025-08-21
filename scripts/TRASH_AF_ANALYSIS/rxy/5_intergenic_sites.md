# Intergenic Sites
Obtain 2 sets of intergeic sites for Rxy normalization. 

## Obtain Intergenic Regions 
```bash
#Set Variables
annotations="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sift4g/AnnotationsSplit"
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

# #Obtain Transcript Regions
# for i in `cat $scripts/autochrs.txt`; do
#     cut -f 1,3-5 $annotations/mywagenomev2.1.gene_chr1.gtf | grep "transcript" | cut -f 1,3,4 >>  $basedir/muts/genic/${i}_genic.bed; 
# done

# #Derived Sites (BED)
# for i in `cat $scripts/autochrs.txt`; do
#     awk '{print $1, $2-1, $2}' OFS="\t" $basedir/polar/chKIWA_der_${i}.keyvalues >> $basedir/polar/bed/chKIWA_der_${i}.bed; 
# done

#Intersect -v Derived Sites and Genic Regions
for i in `cat $scripts/autochrs.txt`; do
    bedtools intersect -v -a $basedir/polar/bed/chKIWA_der_${i}.bed -b $basedir/muts/genic/${i}_genic.bed >> $basedir/muts/chKIWA_der_intergenic.bed;
done
```

## Sample Intergenic Sites
Sample 2 sets of 10K sites, then sort
```bash
#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

# #Randomly sample 10K intergenic sites
# shuf -n 10000 $basedir/muts/chKIWA_der_intergenic.bed >> $basedir/muts/chKIWA_der_intergenic1_unsorted.bed
# shuf -n 10000 $basedir/muts/chKIWA_der_intergenic.bed >> $basedir/muts/chKIWA_der_intergenic2_unsorted.bed

# #Sort by CHR and POS
# for i in `cat $scripts/autochrs.txt`; do 
#     grep -E "${i}\b" $basedir/muts/chKIWA_der_intergenic1_unsorted.bed | sort -k3n >> $basedir/muts/chKIWA_der_intergenic1.bed
#     grep -E "${i}\b" $basedir/muts/chKIWA_der_intergenic2_unsorted.bed | sort -k3n >> $basedir/muts/chKIWA_der_intergenic2.bed;
# done
```

## Extract Intergenic Regions From cKIWA and hKIWA
```bash
nano $scripts/derived_intergenic.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_hc_default
#SBATCH --job-name=intergenic_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

# # Create Keys
# awk '{print $1"_"$3}' OFS="\t" $basedir/muts/chKIWA_der_intergenic1.bed >> $basedir/muts/chKIWA_der_intergenic1.key
# awk '{print $1"_"$3}' OFS="\t" $basedir/muts/chKIWA_der_intergenic2.bed >> $basedir/muts/chKIWA_der_intergenic2.key

#Merge with cKIWA keyvalues
for i in `cat $scripts/autochrs.txt`; do
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/cKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_intergenic1.key >> $basedir/mafs/derived_mutations/cKIWA_der_intergenic1.temp
done

for i in `cat $scripts/autochrs.txt`; do
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/cKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_intergenic2.key >> $basedir/mafs/derived_mutations/cKIWA_der_intergenic2.temp
done

#Merge with hKIWA keyvalues
for i in `cat $scripts/autochrs.txt`; do
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/hKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_intergenic1.key >> $basedir/mafs/derived_mutations/hKIWA_der_intergenic1.temp
done

for i in `cat $scripts/autochrs.txt`; do
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/mafs/hKIWA_${i}.keyvalues $basedir/muts/chKIWA_der_intergenic2.key >> $basedir/mafs/derived_mutations/hKIWA_der_intergenic2.temp
done


```