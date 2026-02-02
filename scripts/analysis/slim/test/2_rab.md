# RAB


```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/test"
vcf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/test/rec_test.vcf'
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

#activate env
source ~/RABvcfs_env/bin/activate


#Run RABmafs
python3 $scripts/RABvcfs.py --vcf $vcf --pop $scripts/pops.txt --fileN $work/intergenic20.txt --fileM $work/strong20.txt --seed 8 --psites 0.30 --iter 5