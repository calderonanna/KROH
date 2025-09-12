## Derive Sites
Defined as sites in the outgroup (HOWA_AMRE), where the major allele is the same as reference allele AND is also fixed, interesected with ingroup sites where the minor allele is different from the ref and segregating. 


```bash
nano $scripts/derive.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=polar
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

#POLARIZE SITES
for i in $(cat $scripts/autochrs.txt); do
    #Subset outgroup fixed sites
    zgrep -E "^${i}\b" $maf/HOWA_AMRE.mafs.gz \
        | awk '$3 == $5 && $6 < 0.01' \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt

    #Subset ingroup segregating sites
    zgrep -E "^${i}\b" $maf/chKIWA.mafs.gz \
        | awk '$3 == $5 && $6 > 0.01' \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/chKIWA_min_seg_${i}.txt
    
    #Intersect outgroup_fixed and ingroup_segregating
    grep -F -f $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt \
        $derived/chKIWA_min_seg_${i}.txt \
        > $derived/derived_${i}.txt;
done

#FILTER SITES 
zcat $maf/cKIWA.mafs.gz | awk '$7>=3' >> $maf/cKIWA_nInd.maf
zcat $maf/hKIWA.mafs.gz | awk '$7>=3' >> $maf/hKIWA_nInd.maf

#DERIVE SITES
for i in `cat $scripts/autochrs.txt`; do
    #Create site ids cKIWA
    zgrep -E "^${i}\b" $maf/cKIWA_nInd.maf \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/cKIWA_${i}.txt

    #Create site ids hKIWA
    zgrep -E "^${i}\b" $maf/hKIWA_nInd.maf \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/hKIWA_${i}.txt

    #Intersect cKIWA and hKIWA
    grep -F -f $derived/cKIWA_${i}.txt \
        $derived/hKIWA_${i}.txt \
        > $derived/KIWA_${i}.txt

    #Intersect KIWA with Derived
    grep -F -f $derived/KIWA_${i}.txt \
        $derived/derived_${i}.txt \
        > $derived/KIWA_derived_${i}.keys

    #Extract derived sites from cKIWA.maf
    zgrep -E "^${i}\b" $maf/cKIWA.mafs.gz \
        | awk '{print $0, $1"_"$2"_"$3$4$5}' \
        > $derived/cKIWA_${i}.keyvalues

    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' \
        $derived/cKIWA_${i}.keyvalues \
        $derived/KIWA_derived_${i}.keys \
        | sed 's/ /\t/g' | cut -f 1-7 \
        >> $maf/cKIWA_derived.maf

    #Extract derived sites from hKIWA.maf
    zgrep -E "^${i}\b" $maf/hKIWA.mafs.gz \
        | awk '{print $0, $1"_"$2"_"$3$4$5}' \
        > $derived/hKIWA_${i}.keyvalues

    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' \
        $derived/hKIWA_${i}.keyvalues \
        $derived/KIWA_derived_${i}.keys \
        | sed 's/ /\t/g' | cut -f 1-7 \
        >> $maf/hKIWA_derived.maf;
done
```

#File Clean up 
  
    #File cleanup
    rm -rf $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt 
    rm -rf $derived/chKIWA_min_seg_${i}.txt
        #File cleanup
    rm -rf $derived/cKIWA_${i}.keyvalues
    rm -rf $derived/hKIWA_${i}.keyvalues
    rm -rf $derived/KIWA_derived_${i}.keys
    rm -rf $derived/cKIWA_${i}.txt
    rm -rf $derived/hKIWA_${i}.txt
    rm -rf $derived/KIWA_${i}.txt
    rm -rf $derived/derived_${i}.txt