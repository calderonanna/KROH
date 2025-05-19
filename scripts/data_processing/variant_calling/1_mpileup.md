# Call Variants samtools mpileup
Lefouili and Nam 2022 shows the outerperformace of mpileup over GATK HaplotypeCallder after hard filtering. GATK VQSR however was show to outerperform Bcftools mpileup only when coverage is low. Given that I'm calling both contemporary and historical together, I'm going to use mpileup. I'm also using mpileup when calling variants used in GONE, so figure its best to not mix and match tools. 
 
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

# #Create a bam list
# for i in `cat $scripts/cKIWA_IDS.txt`; do
#     realpath $data/bam/${i}_marked.bam >> $data/vcf/bam_list.txt;
# done

# for i in `cat $scripts/hKIWA_e759877_IDS.txt`; do
#     realpath $data/mapdamage/${i}/${i}_marked.rescaled.bam \
#     >> $data/vcf/bam_list.txt;
# done

#Call Variants
bcftools mpileup \
    -f $ref \
    -b $data/vcf/bam_list.txt \
    -a FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR | \
    bcftools call -f GQ -mv --ploidy 2 -Oz -o $data/vcf/KIWA.vcf.gz
```
