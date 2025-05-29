# Calculate Rxy

- Pop A = Contemporary KIWA
- Pop B = Historical KIWA

- Rxy > 1: enrichment of derived alleles in pop A
- Rxy = 1: no difference
- Rxy < 1: purging of derived alleles in pop A

```bash
#Set Variables
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
vcf="KIWA_private.vcf.gz"

$rxy/Rxy-kin.py \
    -v $work_dir/$vcf \
    -1 $work_dir/inter2.txt \
    -2 $work_dir/inter1.txt \
    -A $work_dir/pop_A.txt \
    -B $work_dir/pop_B.txt

#Paste Results Into File
echo "0.32499749914325105 0.3183392916610649 0.3312535074291167 TOLERATED INTER1" >> rxy_results.txt
echo "0.29831511629022667 0.2890638201104485 0.3083392512620085 DELETERIOUS INTER1" >> rxy_results.txt
echo "0.35130362970970314 0.3087377751061352 0.38848419139572826 LOSSOFFUNCTION INTER1" >> rxy_results.txt
echo "0.3052010190345742 0.29736513307349594 0.31200736330038353 NONSYNONYMOUS INTER1" >> rxy_results.txt
echo "0.3311452081418436 0.32420247302420485 0.34045595796484635 SYNONYMOUS INTER1" >> rxy_results.txt
echo "0.28689350271212266 0.2808160551919428 0.2935298497743061 NONCODING INTER1" >> rxy_results.txt

echo "0.31359232733920595 0.30732408102642206 0.32042063730763676 TOLERATED INTER2" >> rxy_results.txt
echo "0.2878463121855709 0.27715631631434784 0.29504134481314037 DELETERIOUS INTER2" >> rxy_results.txt
echo "0.33897529406777943 0.30575358526378477 0.3763873099475822 LOSSOFFUNCTION INTER2" >> rxy_results.txt
echo "0.29449056721252903 0.2884837941820158 0.3026985539414988 NONSYNONYMOUS INTER2" >> rxy_results.txt
echo "0.3195242941320429 0.31282813457752673 0.3273645825790622 SYNONYMOUS INTER2" >> rxy_results.txt
echo "0.27682551850756176 0.26997033664793085 0.2840378487853537 NONCODING INTER2" >> rxy_results.txt


# 
awk '{print $1, $2-1, $2}' OFS="\t" $work_dir/noncode.txt \
    > noncode.bed
sed -i '1d' noncode.bed

bcftools view -T $work_dir/noncode.bed \
    $work_dir/$vcf | grep -v ^## | wc -l 