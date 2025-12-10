# Divstats Windows

```bash
nano $scripts/divstats_windows.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=300GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_hc_default 
#SBATCH --job-name=divstats_windows
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
bin="/storage/group/zps5164/default/bin"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
work="/storage/group/zps5164/default/abc6435/KROH/data/divstats"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

for i in $(cat $scripts/autochrs.txt); do
    #Extract Chr
    bcftools view $allsites/hKIWA_allsites_bi_dp_qual.vcf.gz -r ${i} -Oz -o $allsites/hKIWA_allsites_bi_dp_qual_${i}.vcf.gz

    #Run Divstats
    $bin/divstats \
    --pi \
    --vcf $allsites/hKIWA_allsites_bi_dp_qual_${i}.vcf.gz \
    --winsize 100000 \
    --sites \
    --winstep 1 \
    --out $work/hKIWA_window_${i} \
    --threads 4

    rm -rf $allsites/hKIWA_allsites_bi_dp_qual_${i}.vcf.gz
done

for i in $(cat $scripts/autochrs.txt); do
    #Extract Chr
    bcftools view $allsites/dcKIWA_allsites_bi_dp_qual.vcf.gz -r ${i} -Oz -o $allsites/dcKIWA_allsites_bi_dp_qual_${i}.vcf.gz

    #Run Divstats
    $bin/divstats \
    --pi \
    --vcf $allsites/dcKIWA_allsites_bi_dp_qual_${i}.vcf.gz \
    --winsize 100000 \
    --sites \
    --winstep 1 \
    --out $work/dcKIWA_window_${i} \
    --threads 4

    rm -rf $allsites/dcKIWA_allsites_bi_dp_qual_${i}.vcf.gz
done
```
