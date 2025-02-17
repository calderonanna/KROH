# Prepare VCF Files
GONE does not need all sites in a vcf to run (it actually might crash the program). In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome and no more than 10 Million SNPS genome-wide. 

## Split VCF by chromosomes
Note: You only have to do this step once.
```bash
#Set Variables and make replicate directories
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/clean_vcf.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"

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

#Split VCF by CHR
for i in "${chr_list[@]}"; do
    bcftools view $vcf_folder/auto_nmiss.vcf.gz -r ${i} -Oz -o $vcf_folder/${i}.vcf.gz; 
done

#Remove uncessary vcf files
rm -rf $vcf_folder/auto*
```
