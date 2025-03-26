# Calculate Rxy


```bash
#Set Variables
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

$rxy/Rxy-kin.py -v $data/rxy/nomissing_gt.vcf.gz -1 $data/rxy/del.txt -2 $data/rxy/intergenic_v2_sorted.txt -A $data/rxy/pop_A.txt -B $data/rxy/pop_B.txt