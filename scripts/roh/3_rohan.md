# ROHan

## Obtain Ts/Tv Ratio
Comparing Ref to Alt, obtain the number of transitions from purines A↔G and prymidines C↔T. Then obtain the number of transerversions from purines to prymidines (A↔C, A↔T, G↔C, G↔T). Takes the ratio of Transitions (Ts) and Transversions. This will then be used in rohan to improve the accuracy of ROH inference. 

```bash
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf" 
bcftools stats $vcf_dir/chKIWA_AMRE_HOWA.vcf.gz | grep TSTV

$ bcftools stats chKIWA_AMRE_HOWA.vcf.gz | grep TSTV
# TSTV, transitions/transversions:
# TSTV  [2]id   [3]ts   [4]tv   [5]ts/tv        [6]ts (1st ALT) [7]tv (1st ALT) [8]ts/tv (1st ALT)
#TSTV    0       68053741        33571759        2.03    66763261        31253955   2.14
```

## Historical
Since DNA damage was not too extensive, we skipped the filtering step for reads in highly mappable regions.
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/h_rohan.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=h_rohan
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf" 
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/rohan"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan/bin/rohan"
mywa="/storage/home/abc6435/ToewsLab/mywa_genome_2/final_assembly"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
seq_stats="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seq_stats"

#Filter regions with coverage > 0 and Run rohan
for i in `cat $scripts/hKIWA_IDS.txt`; do
    awk '$3>0' $seq_stats/${i}_depth.txt \
        | awk '{print $1"\t"$2-1"\t"$2}' \
        > $work/covpos_${i}.bed

    bedtools merge -i \
        $work/covpos_${i}.bed \
        > $work/covreg_${i}.bed
    
    $rohan \
        --tstv 2.03 \
        --rohmu 1.4e-9 \
        --deam5p $work/${i}_marked_classic_*_5p.prof \
        --deam3p $work/${i}_marked_classic_*_3p.prof \
        --auto $vcf_dir/chrs.txt \
        --bed $work/covreg_${i}.bed \
        -o $work/results/${i} \
        $mywa/mywagenomev2.1.fa \
        $bam/${i}_marked.bam;
done

```
## Contemporary 
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/c_rohan.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=c_rohan
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf" 
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/rohan"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
rohan="/storage/home/abc6435/SzpiechLab/bin/rohan/bin/rohan"
mywa="/storage/home/abc6435/ToewsLab/mywa_genome_2/final_assembly"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"


for i in `cat $scripts/cKIWA_IDS.txt`; do
    $rohan \
        --tstv 2.03 \
        --rohmu 1.4e-9 \
        --auto $vcf_dir/chrs.txt \
        -o $work/results/${i} \
        $mywa/mywagenomev2.1.fa \
        $bam/${i}_marked.bam;
done