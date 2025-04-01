# Fst

```bash
#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

vcftools --gzvcf $data/vcf/$vcf \
    --weir-fst-pop $scripts/cKIWA_IDS.txt \
    --weir-fst-pop $scripts/hKIWA_IDS.txt \
    --fst-window-step 5000 \
    --out $data/pop_structure/fst

#Correct Negative Fst Values (set equal to 0)
awk '{if ($3 < 0) print $1, $2, 0; else print $0}' OFS="\t" fst.weir.fst >> fst_corrected.txt

#calculate Genome-wide Mean Fst
awk '{sum+=$3; count+=1} END {print sum/count}' fst_corrected.txt

#[OUTPUT]: 0.0563839