# Sample Chromosomes
GONE does not need all sites in a vcf to run (it actually might crash the program). In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome and no more than 10 Million SNPS genome-wide. 

## Sample VCF by chromosomes
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/sample_vcf_kirt.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))

#Make Directories
mkdir $vcf_folder/200K $vcf_folder/400K $vcf_folder/600K

#Split VCF by CHR and randomly sample sites 
for i in "${chr_list[@]}"; do
    bcftools view $vcf_folder/auto_nmiss.vcf.gz -r ${i} -Oz -o $vcf_folder/${i}.vcf.gz
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 200000 | cut -f1,2 > $vcf_folder/200K/${i}_sites.txt
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 400000 | cut -f1,2 > $vcf_folder/400K/${i}_sites.txt
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 600000 | cut -f1,2 > $vcf_folder/600K/${i}_sites.txt;
done

#Extract sites from vcf files and index
for i in "${chr_list[@]}"; do
    bcftools view -T $vcf_folder/200K/${i}_sites.txt -Oz -o $vcf_folder/200K/${i}_sites.vcf.gz $vcf_folder/${i}.vcf.gz
    bcftools index $vcf_folder/200K/${i}_sites.vcf.gz
    bcftools view -T $vcf_folder/400K/${i}_sites.txt -Oz -o $vcf_folder/
    400K/${i}_sites.vcf.gz $vcf_folder/${i}.vcf.gz
    bcftools index $vcf_folder/400K/${i}_sites.vcf.gz
    bcftools view -T $vcf_folder/600K/${i}_sites.txt -Oz -o $vcf_folder/600K/${i}_sites.vcf.gz $vcf_folder/${i}.vcf.gz
    bcftools index $vcf_folder/600K/${i}_sites.vcf.gz
done

#Merge, sort, and rename 
cd $vcf_folder/200K
bcftools concat -Oz -o merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o merged_sorted.vcf.gz merged.vcf.gz
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -Oz -o $vcf_folder/200K/gone_200K.vcf.gz $vcf_folder/200K/merged_sorted.vcf.gz

cd $vcf_folder/400K
bcftools concat -Oz -o merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o merged_sorted.vcf.gz merged.vcf.gz
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -Oz -o $vcf_folder/400K/gone_400K.vcf.gz $vcf_folder/400K/merged_sorted.vcf.gz

cd $vcf_folder/600K
bcftools concat -Oz -o merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o merged_sorted.vcf.gz merged.vcf.gz
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -Oz -o $vcf_folder/600K/gone_600K.vcf.gz $vcf_folder/600K/merged_sorted.vcf.gz
 ```