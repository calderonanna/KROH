# Extract
- intersects cKIWA and hKIWA sites (KIWA)
- intersects KIWA with derived
- Extracts the derived allele frequencies from cKIWA.maf and hKIWA.maf

```bash
nano $scripts/extract_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=8:00:00
#SBATCH --account=open
#SBATCH --job-name=extract_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
maf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/maf'
derived='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/angsd/derived'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
err='/storage/home/abc6435/SzpiechLab/abc6435/KROH/err'

for i in `cat $scripts/autochrs.txt`; do

    #Create site ids cKIWA
    zgrep -E "^${i}\b" $maf/cKIWA_nInd.maf \
        | awk '{print $1"_"$2"_"$3$4$5}' \
        > $derived/cKIWA_${i}.txt
    echo "created chrom_pos_min_maj_ref: cKIWA_${i}" >> $err/derive.log

    #Create site ids hKIWA
    zgrep -E "^${i}\b" $maf/hKIWA_nInd.maf \
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

    #Extract derived sites from cKIWA.maf
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