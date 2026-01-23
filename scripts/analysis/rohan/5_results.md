# Results

```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
results="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan/results"

#Genome-wide theta outside ROH
echo -e "sample\tthetamid\tthetamin\tthetamax" > gw_theta_outside_ROH.txt
for i in $(cat $scripts/KIWA_IDS_e759877.txt); do
    grep "^Genome-wide theta outside ROH:" ${i}.summary.txt \
    | sed "s/^Genome-wide theta outside ROH:/$i/" >> gw_theta_outside_ROH.txt
done

#Genome-wide theta inc. ROH
echo -e "sample\tthetamid\tthetamin\tthetamax" > gw_theta_inc_ROH.txt
for i in $(cat $scripts/KIWA_IDS_e759877.txt); do
    grep "^Genome-wide theta inc. ROH:" ${i}.summary.txt \
    | sed "s/^Genome-wide theta inc. ROH:/$i/" >> gw_theta_inc_ROH.txt
done

#Segments in ROH(%)
echo -e "sample\tROH(%)\tCI" > percent_ROH.txt
for i in $(cat $scripts/KIWA_IDS_e759877.txt); do
    grep "^Segments in ROH(%)       :" ${i}.summary.txt \
    | sed "s/^Segments in ROH(%)       :/$i/" \
    | sed "s/ /\t/g" >> percent_ROH.txt
done

#NROH and SROH
echo "sample,sroh,nroh,hmm_posterior_decoding" > nroh_sroh.txt
for i in $(cat $scripts/KIWA_IDS_e759877.txt); do
  for type in min mid max; do
    zcat ${i}.${type}.hmmrohl.gz \
    | awk -v sample="$i" -v t="$type" 'NR>1 {sum += $5; count++} END {print sample, sum, count, t}' OFS="," \
    >> nroh_sroh.txt
  done
done

#Heterozygosity
echo -e "chrom\tend\th\thlow\thhigh\tsample\tpop" > het.txt
for i in $(cat $scripts/hKIWA_IDS_e759877.txt); do
  zcat ${i}.hEst.gz \
  | awk -v sample="$i" 'NR>1 {print $1,$3,$5,$7,$8,sample,"hKIWA"}' OFS="\t" \
  >> het.txt
done

for i in $(cat $scripts/cKIWA_IDS.txt); do
  zcat ${i}.hEst.gz \
  | awk -v sample="$i" 'NR>1 {print $1,$3,$5,$7,$8,sample,"cKIWA"}' OFS="\t" \
  >> het.txt
done

#Coverage
grep "coverage=" * \
| sed -E 's/\.err.*coverage=/\t/' > rohan_cov.txt
```