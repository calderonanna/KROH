# Rxy-kin
NEEDS DERIVED SITES

```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/vcf"


#Filter Missing Data
bcftools view -i 'N_MISSING = 0' $gatk/KIWA_bi_qual_gtdp_gtgq.vcf.gz -Oz -o $gatk/KIWA_bi_qual_gtdp_gtgq_nmiss.vcf.gz

#Run Rxy-kin
$bin/Rxy-kin.py \
-v $gatk/KIWA_bi_qual_gtdp_gtgq_nmiss.vcf.gz \
-1 $work/4fold_synonymous.txt \
-2 $work/deleterious.txt \
-A $scripts/hKIWA_IDS_e759877.txt \
-B $scripts/cKIWA_IDS.txt \
| awk '{print $0, "deleterious"}' OFS="\t" \
>> $work/rxy.txt