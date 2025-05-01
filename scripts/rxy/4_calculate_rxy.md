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
vcf2="chKIWA_AMRE_HOWA_tags_auto_bi_e759877_nmiss.vcf.gz"

$rxy/Rxy-kin.py \
    -v $work_dir/$vcf2 \
    -1 $work_dir/del.txt \
    -2 $work_dir/inter1.txt \
    -A $work_dir/pop_A.txt \
    -B $work_dir/pop_B.txt

#Paste Results Into File
echo "4.261136225147747 4.1675793645504635 4.380559237632598 TOLERATED INTER1" >> rxy_results.txt
echo "4.290940641408234 4.180711470651449 4.414105398816692 TOLERATED INTER2" >> rxy_results.txt
echo "4.290940641408234 4.180711470651449 4.414105398816692 DELETERIOUS INTER1" >> rxy_results.txt