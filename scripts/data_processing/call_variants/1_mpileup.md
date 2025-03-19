# Call Variants samtools mpileup
Lefouili and Nam 2022 shows the outerperformace of mpileup over GATK HaplotypeCallder after hard filtering. GATK VQSR however was show to outerperform Bcftools mpileup only when coverage is low. Given that I'm calling both contemporary and historical together, I'm going to use mpileup. I'm also using mpileup when calling variants used in GONE, so figure its best to not mix and match tools. 
 

## Alignments
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/call_variants_KIWA.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=80:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=call_variants_KIWA
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference/mywagenomev2.1.fa"
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

#Create a bam list
cd /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam
realpath *marked.bam > $vcf_dir/bam_list.txt

#Call Variants
bcftools mpileup -f $ref -b $vcf_dir/bam_list.txt | bcftools call -f GQ -mv --ploidy 2 -Oz -o $vcf_dir/KIWA.vcf.gz
```
