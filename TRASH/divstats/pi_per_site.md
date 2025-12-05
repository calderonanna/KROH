# Pi Per Site
```bash
# Pi Per Site
```bash
salloc --nodes=1 --mem=50GB --ntasks=4 --time=5:00:00 --account=open

#Set Variables
bin="/storage/group/zps5164/default/bin"
vcf="/storage/group/zps5164/default/abc6435/KROH/data/gatk/vcf"
work="/storage/group/zps5164/default/abc6435/KROH/data/divstats"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
ref="/storage/group/zps5164/default/abc6435/KROH/data/mywa_reference"

for i in $(cat $scripts/autochrs.txt); do
    for j in dc h; do

        # Extract chromosome
        bcftools view $vcf/${j}KIWA_auto_bi_qual_dp_gq.vcf.gz -r ${i} -Oz -o $vcf/${j}KIWA_auto_bi_qual_dp_gq_${i}.vcf.gz

        # Run Divstats
        $bin/divstats \
            --pi \
            --vcf $vcf/${j}KIWA_auto_bi_qual_dp_gq_${i}.vcf.gz \
            --winsize 1 \
            --sites \
            --winstep 1 \
            --out $work/${j}KIWA_${i} \
            --threads 4

        # Concatenate results (skip header)
        sed '1d' $work/${j}KIWA_${i}.divstats.out | cut -f1,2,6 \
            >> $work/${j}KIWA.divstats.out

        # File cleanup
        rm -f $vcf/${j}KIWA_auto_bi_qual_dp_gq_${i}.vcf.gz
        rm -f $vcf/${j}KIWA_auto_bi_qual_dp_gq_${i}.vcf.gz.csi
        rm -f $work/${j}KIWA_${i}.divstats.out

    done
done


```

## Compile Results
```bash
autosomal_length=$(grep "chr" $ref/mywagenomev2.1.fa.fai | awk '{sum+=$2} END{print sum}')

echo "${j}KIWA" >> $work/results.txt
awk -v len="$autosomal_length" '{sum_pi+=$3} END {print sum_pi/len}' "$work/${j}KIWA.divstats.out" >> $work/results.txt

echo "hKIWA" >> $work/results.txt
awk -v len="$autosomal_length" '{sum_pi+=$3} END {print sum_pi/len}' "$work/hKIWA.divstats.out" >> $work/results.txt

echo -e "CHR\tPOS\tPI\tPOP" >> $work/divstats_sites.txt
awk '{print $0, $4="cKIWA"}' OFS="\t"  ${j}KIWA.divstats.out >> divstats_sites.txt
awk '{print $0, $4="hKIWA"}' OFS="\t" hKIWA.divstats.out >> divstats_sites.txt

#File Clean Up
rm -rf dcKIWA.divstats.out hKIWA.divstats.out
```
## Compile Results
```bash
autosomal_length=$(grep "chr" $ref/mywagenomev2.1.fa.fai | awk '{sum+=$2} END{print sum}')

echo "dcKIWA" >> $work/results.txt
awk -v len="$autosomal_length" '{sum_pi+=$3} END {print sum_pi/len}' "$work/dcKIWA.divstats.out" >> $work/results.txt

echo "hKIWA" >> $work/results.txt
awk -v len="$autosomal_length" '{sum_pi+=$3} END {print sum_pi/len}' "$work/hKIWA.divstats.out" >> $work/results.txt

#File Clean Up
rm -rf dcKIWA.divstats.out hKIWA.divstats.out
