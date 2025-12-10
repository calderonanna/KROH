# Divstats Sites

```bash
nano $scripts/divstats_pi_per_site.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=200:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=divstats_pi_per_site
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bin="/storage/group/zps5164/default/bin"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
work="/storage/group/zps5164/default/abc6435/KROH/data/divstats"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
ref="/storage/group/zps5164/default/abc6435/KROH/data/mywa_reference"

# #Filter Samples and Index
# bcftools view -S $scripts/cKIWA_IDS.txt $allsites/dKIWA_allsites_bi_dp_qual.vcf.gz -Oz -o $allsites/dcKIWA_allsites_bi_dp_qual.vcf.gz

# bcftools view -S $scripts/hKIWA_IDS_e759877.txt $allsites/dKIWA_allsites_bi_dp_qual.vcf.gz -Oz -o $allsites/hKIWA_allsites_bi_dp_qual.vcf.gz

nohup tabix $allsites/dcKIWA_allsites_bi_dp_qual.vcf.gz
nohup tabix $allsites/hKIWA_allsites_bi_dp_qual.vcf.gz

#Run Divstats
for i in $(cat $scripts/autochrs.txt); do
    for j in dc h; do

        # Extract chromosome
        bcftools view $allsites/${j}KIWA_allsites_bi_dp_qual.vcf.gz -r ${i} -Oz -o $allsites/${j}KIWA_allsites_bi_dp_qual_${i}.vcf.gz

        # Run Divstats
        $bin/divstats \
            --pi \
            --vcf $allsites/${j}KIWA_allsites_bi_dp_qual_${i}.vcf.gz \
            --winsize 1 \
            --sites \
            --winstep 1 \
            --out $work/${j}KIWA_${i} \
            --threads 4
    done
done
```

## Compile Results
```bash
        # Concatenate results (skip header)
        sed '1d' $work/${j}KIWA_${i}.divstats.out | cut -f1,2,6 \
            >> $work/${j}KIWA.divstats.out

        # File cleanup
        rm -f $allsites/${j}KIWA_allsites_bi_dp_qual_${i}.vcf.gz
        rm -f $allsites/${j}KIWA_allsites_bi_dp_qual_${i}.vcf.gz.csi
        rm -f $work/${j}KIWA_${i}.divstats.out

    done
done


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
