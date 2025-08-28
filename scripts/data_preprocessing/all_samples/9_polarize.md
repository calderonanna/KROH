## Polarize Sites
Defined as sites in the outgroup (HOWA_AMRE), where the major allele is the same as reference allele AND is also fixed, interesected with ingroup sites where the minor allele is different from the ref and segregating. 

```bash
nano $scripts/polarize.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=polarize
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

# Set Variables
workdir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#AMRE_HOWA: Maj = Ref && Maj > 0.99 (Min < 0.01)
zcat $workdir/maf/HOWA_AMRE.mafs.gz | awk '$3 == $5 && $6 < 0.01' > $workdir/polar/HOWA_AMRE_maj_ref_fixed.mafs

#chKIWA: Maj = Ref && Min > 0.01
zcat $workdir/maf/chKIWA.mafs.gz | awk '$3 == $5 && $6 > 0.01' > $workdir/polar/chKIWA_min_seg.mafs

#Create BED
awk '{print $1, $2-1, $2}' OFS="\t" $workdir/polar/HOWA_AMRE_maj_ref_fixed.mafs > $workdir/polar/HOWA_AMRE_maj_ref_fixed.bed

awk '{print $1, $2-1, $2}' OFS="\t" $workdir/polar/chKIWA_min_seg.mafs > $workdir/polar/chKIWA_min_seg.bed 

#Intersect Sites 
for i in `cat $scripts/autochrs.txt`; do 
    #-a
    grep -E "^${i}\b" $workdir/polar/chKIWA_min_seg.bed > $workdir/polar/chKIWA_min_seg_${i}.bed
    #-b
    grep -E "^${i}\b" $workdir/polar/HOWA_AMRE_maj_ref_fixed.bed > $workdir/polar/HOWA_AMRE_maj_ref_fixed_${i}.bed
    #bcfools intersect -a -b
    bedtools intersect -a $workdir/polar/chKIWA_min_seg_${i}.bed -b $workdir/polar/HOWA_AMRE_maj_ref_fixed_${i}.bed | cut -f 1,3 >> $workdir/polar/chKIWA_derived.txt
    #clean up
    rm -rf $workdir/polar/chKIWA_min_seg_${i}.bed
    rm -rf $workdir/polar/HOWA_AMRE_maj_ref_fixed_${i}.bed;
done
```