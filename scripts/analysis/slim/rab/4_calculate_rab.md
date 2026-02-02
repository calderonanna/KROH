# Calculate RAB

```bash
#Set Variables
data="/storage/group/zps5164/default/abc6435/KROH/data"
work="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf"
vcf='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/slim/vcf/rec.vcf'
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

#activate env
source ~/RABvcfs_env/bin/activate

#Unzip vcf file
bgzip -d $work/rec.vcf.gz
rm -rf $work/rec.vcf.gz.csi


#Run RABmafs
python3 $scripts/RABvcfs.py \
--vcf $vcf \
--pop $scripts/pops.txt \
--fileN $work/intergenic.txt \
--fileM $work/strong.txt \
--seed 108 \
--psites 0.30 \
--iter 5 \
--simulated_vcf 