# Call Variants
  
## Create Script
```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts/call_variants.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=call_variants
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

# #Bamlist (Non-downsampled)
# for i in `cat $scripts/cKIWA_IDS.txt`; do
#     realpath $data/bam/${i}_marked.bam >> $data/vcf/bam_list.txt;
# done

# for i in `cat $scripts/hKIWA_e759877_IDS.txt`; do
#     realpath $data/mapdamage/${i}/${i}_marked.rescaled.bam \
#     >> $data/vcf/bam_list.txt;
# done

#Bamlist (Downsampled)
realpath $data/bam/downsampled/*.bam >> $data/vcf/bam_list_downsampled.txt;

for i in `cat $scripts/hKIWA_e759877_IDS.txt`; do
    realpath $data/mapdamage/${i}/${i}_marked.rescaled.bam \
    >> $data/vcf/bam_list_downsampled.txt;
done

# #Call Variants (Non-Downsampled)
# bcftools mpileup \
#     -f $ref \
#     -b $data/vcf/bam_list.txt \
#     -a FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR | \
#     bcftools call -f GQ -mv --ploidy 2 -Oz -o $data/vcf/KIWA.vcf.gz

#Call Variants (Downsampled)
bcftools mpileup \
    -f $ref \
    -b $data/vcf/bam_list_downsampled.txt \
    -a FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR | \
    bcftools call -f GQ -mv --ploidy 2 -Oz -o $data/vcf/KIWA_dowsampled.vcf.gz
```
