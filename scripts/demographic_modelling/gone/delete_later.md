## Clean VCF 
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/gone_vcf_kirt.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic

#Set Variables
vcf=""
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

mkdir $vcf_folder

#Make a list of chromosome names
bcftools query -f '%CHROM\n' "$vcf" | uniq > $vcf_folder/rename_chr.txt
awk '{print $1,$2="chr"NR}' OFS="\t" $vcf_folder/rename_chr.txt > $vcf_folder/temp && mv -f $vcf_folder/temp $vcf_folder/rename_chr.txt

#Extract autosomes and exclude missing data
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))
chr_string=$(IFS=,; echo "${chr_list[*]}")

bcftools view $vcf -r $chr_string -Oz -o $vcf_folder/auto.vcf.gz
bcftools view -e 'GT="./."' $vcf_folder/auto.vcf.gz -Oz -o $vcf_folder/auto_nmiss.vcf.gz
bcftools index $vcf_folder/auto_nmiss.vcf.gz
```