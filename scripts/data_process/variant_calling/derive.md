## Derive Sites
Defined as sites in the outgroup (HOWA_AMRE), where the major allele is the same as reference allele AND is also fixed, interesected with ingroup sites where the minor allele is different from the ref and segregating. 

derived.txt intersect with KIWA.txt
```bash
nano $scripts/derive.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=derive
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
err='/storage/home/abc6435/SzpiechLab/abc6435/KROH/err'

#POLARIZE SITES
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

#FILTER SITES (NIND>=3, TRANSVERSIONS)
zcat $maf/cKIWA.mafs.gz | awk '$7>=3' >> $maf/cKIWA_nInd.maf
zcat $maf/hKIWA.mafs.gz | awk '$7>=3' >> $maf/hKIWA_nInd.maf

awk 'NR==1 {print; next} !((($3=="C" && $4=="T") || ($3=="T" && $4=="C") || ($3=="G" && $4=="A") || ($3=="A" && $4=="G"))) {print}' $maf/cKIWA_nInd.maf >> $maf/cKIWA_nInd_transv.maf

awk 'NR==1 {print; next} !((($3=="C" && $4=="T") || ($3=="T" && $4=="C") || ($3=="G" && $4=="A") || ($3=="A" && $4=="G"))) {print}' $maf/hKIWA_nInd.maf >> $maf/hKIWA_nInd_transv.maf

#DERIVE SITES
for i in `cat $scripts/autochrs.txt`; do
    #Create site ids cKIWA
    zgrep -E "^${i}\b" $maf/cKIWA_nInd_transv.maf \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/cKIWA_${i}.txt
    echo "created chrom_pos_min_maj_ref: cKIWA_${i}" >> $err/derive.log

    #Create site ids hKIWA
    zgrep -E "^${i}\b" $maf/hKIWA_nInd_transv.maf \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/hKIWA_${i}.txt
    echo "created chrom_pos_min_maj_ref: hKIWA_${i}" >> $err/derive.log

    #Intersect cKIWA and hKIWA
    grep -F -f $derived/cKIWA_${i}.txt \
        $derived/hKIWA_${i}.txt \
        > $derived/KIWA_${i}.txt
        echo "intersected cKIWA_${i} with hKIWA_${i}: KIWA_${i}" >> $err/derive.log
    rm -rf $derived/hKIWA_${i}.txt 
    rm -rf $derived/cKIWA_${i}.txt 

    #Intersect KIWA with Derived
    grep -F -f $derived/KIWA_${i}.txt \
        $derived/derived_${i}.txt \
        > $derived/KIWA_derived_${i}.keys
        echo "intersected KIWA_${i} with derived_${i}: KIWA_derived_${i}" >> $err/derive.log
    rm -rf $derived/derived_${i}.txt
    rm -rf $derived/KIWA_${i}.txt

    #Extract frequencies of KIWA_derived
    zgrep -E "^${i}\b" $maf/cKIWA.mafs.gz \
        | awk '{print $0, $1"_"$2"_"$3$4$5}' OFS="\t" \
        > $derived/cKIWA_${i}.keyvalues
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' \
        $derived/cKIWA_${i}.keyvalues \
        $derived/KIWA_derived_${i}.keys \
        | sed 's/ /\t/g' | cut -f 1-7 \
        >> $maf/cKIWA_derived.temp
    rm -rf $derived/cKIWA_${i}.keyvalues

    #Extract derived sites from hKIWA.maf
    zgrep -E "^${i}\b" $maf/hKIWA.mafs.gz \
        | awk '{print $0, $1"_"$2"_"$3$4$5}' OFS="\t" \
        > $derived/hKIWA_${i}.keyvalues
    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' \
        $derived/hKIWA_${i}.keyvalues \
        $derived/KIWA_derived_${i}.keys \
        | sed 's/ /\t/g' | cut -f 1-7 \
        >> $maf/hKIWA_derived.temp
    rm -rf $derived/hKIWA_${i}.keyvalues
    rm -rf $derived/KIWA_derived_${i}.keys;
done

#headers
zcat $maf/cKIWA.mafs.gz | head -1 > cKIWA_derived.maf
cat cKIWA_derived.temp >> cKIWA_derived.maf

zcat $maf/hKIWA.mafs.gz | head -1 > hKIWA_derived.maf
cat hKIWA_derived.temp >> hKIWA_derived.maf

#File Clean Up 
rm -rf $maf/cKIWA_nInd.maf
rm -rf $maf/hKIWA_nInd.maf
rm -rf $maf/cKIWA_nInd_transv.maf
rm -rf $maf/hKIWA_nInd_transv.maf
rm -rf $derived
rm -rf $maf/cKIWA_derived.temp
rm -rf $maf/hKIWA_derived.temp
```