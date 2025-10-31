## Input Files
```bash
salloc --nodes 1 --ntasks 1 --mem=50GB --time=5:00:00 

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet_auto.vcf.gz"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/garlic"
shared="/storage/home/abc6435/SzpiechLab/shared"

#.tped and .tfam
plink \
--vcf $vcf \
--recode transpose \
--double-id \
--chr-set 30 \
--allow-extra-chr \
--out $work/KIWA

awk '$1="kirtlandii"' $work/KIWA.tfam \
> $work/temp && mv -f $work/temp $work/KIWA.tfam

#.tgls
$shared/create_tgls_from_vcf.py $vcf > $work/KIWA.tgls

#centromere.txt
bcftools query -f '%CHROM\n' $vcf | uniq | grep -v -E "^scaffold|^mito|^chrz" > $work/centromere.txt

awk '$1=$1" 0 1"' $work/centromere.txt > $work/temp && mv -f $work/temp $work/centromere.txt
```