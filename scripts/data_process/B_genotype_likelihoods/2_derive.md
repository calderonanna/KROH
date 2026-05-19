# Derive
Defined as sites in the outgroup (HOWA_AMRE), where the major allele is the same as reference allele AND is also fixed, interesected with ingroup sites where the minor allele is different from the ref and segregating. 

```bash
nano $scripts/derive_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --time=100:00:00
#SBATCH --account=zps5164_sc_default
#SBATCH --job-name=derive_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
err='/storage/home/abc6435/SzpiechLab/abc6435/KROH/err'

for i in $(cat $scripts/autochrs.txt); do

    #Subset outgroup fixed sites
    zgrep -E "^${i}\b" $maf/HOWA_AMRE.mafs.gz \
        | awk '$3 == $5 && $6 < 0.01' \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt
    echo "Outgroup fixed sites: ${i}" >> $err/derive.log

    #Subset ingroup segregating sites
    zgrep -E "^${i}\b" $maf/chKIWA.mafs.gz \
        | awk '$3 == $5 && $6 > 0.01' \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/chKIWA_min_seg_${i}.txt
    echo "Ingroup segregating sites: ${i}" >> $err/derive.log
    
    #Intersect outgroup_fixed and ingroup_segregating
    grep -F -f $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt \
        $derived/chKIWA_min_seg_${i}.txt \
        > $derived/derived_${i}.txt
    echo "Intersected fixed and segregating sites: ${i}" >> $err/derive.log
    
    #File Clean Up
    rm -rf $derived/HOWA_AMRE_ref_maj_fixed_${i}.txt
    rm -rf $derived/chKIWA_min_seg_${i}.txt;
done
