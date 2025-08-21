# Extract Derived Sites

```bash
nano $scripts/extract_derived_sites.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=9:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=extract_derived_sites
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

# Set Variables
workdir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'

awk '{print $1"_"$2}' $workdir/polar/chKIWA_derived.txt > $workdir/derived/chKIWA_derived.keys

for i in `cat $scripts/autochrs.txt`; do
    #contemporary
    zgrep -E "^${i}\b" $workdir/maf/cKIWA.mafs.gz | awk '{print $0, $1"_"$2}' OFS="\t" > $workdir/derived/cKIWA_${i}.keyvalues

    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $workdir/derived/cKIWA_${i}.keyvalues $workdir/derived/chKIWA_derived.keys >> $workdir/derived/cKIWA_derived.temp

    rm -rf $workdir/derived/cKIWA_${i}.keyvalues

    #historical
    zgrep -E "^${i}\b" $workdir/maf/hKIWA.mafs.gz | awk '{print $0, $1"_"$2}' OFS="\t" > $workdir/derived/hKIWA_${i}.keyvalues

    awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $workdir/derived/hKIWA_${i}.keyvalues $workdir/derived/chKIWA_derived.keys >> $workdir/derived/hKIWA_derived.temp

    rm -rf $workdir/derived/hKIWA_${i}.keyvalues;
done

#Add Headers
zcat $workdir/maf/cKIWA.mafs.gz | head -1 >> $workdir/derived/cKIWA_derived.maf
zcat $workdir/maf/hKIWA.mafs.gz | head -1 >> $workdir/derived/hKIWA_derived.maf

cut -f 1-7 $workdir/derived/cKIWA_derived.temp >> $workdir/derived/cKIWA_derived.maf
cut -f 1-7 $workdir/derived/hKIWA_derived.temp >> $workdir/derived/hKIWA_derived.maf

rm -rf $workdir/derived/cKIWA_derived.temp
rm -rf $workdir/derived/hKIWA_derived.temp
```