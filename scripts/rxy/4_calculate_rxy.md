# Calculate Rxy

Pop A = Contemporary KIWA
Pop B = Historical KIWA

Rxy > 1: enrichment of derived alleles in pop A

Rxy = 1: no difference

Rxy < 1: purging of derived alleles in pop A

```bash
#Set Variables
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

$rxy/Rxy-kin.py -v $data/rxy/nomissing_gt.vcf.gz -1 $data/rxy/tol.txt -2 $data/rxy/intergenic_v2_sorted.txt -A $data/rxy/pop_A.txt -B $data/rxy/pop_B.txt

echo "1.2244594575037866 1.2101214201222985 1.236188949523863 TOLERATED" >> rxy_v2.txt