# Randomly sample sites 
I will do this several times to create replicates and then run gone several times across these replicates. 

## Create Bash Script
Create several of these scripts for each replicate. Doing this manually because nested loops are ugly and confusing and I literally cannot right now. 
```bash
#Set Variables and make replicate directories
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
cd $vcf_folder
mkdir rep1 rep2 rep3 rep4 rep5 rep6 rep7 rep8 rep9 rep10

nano $scripts_folder/gone_repx_vcf.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
chrom_list=(chr1 chr1a chr2 chr3 chr4 chr4a chr5 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr17 chr18 chr19 chr20 chr21 chr22 chr23 chr24 chr25 chr26 chr27 chr28 chr29)

#Randomly sample sites 
for i in "${chrom_list[@]}"; do
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 100000 | cut -f1,2 > $vcf_folder/repx/${i}_sites.txt; 
done

#Extract sites from vcf files
for i in "${chrom_list[@]}"; do
    bcftools view -T $vcf_folder/repx/${i}_sites.txt -Oz -o $vcf_folder/repx/${i}_sites.vcf.gz $vcf_folder/${i}.vcf.gz;
done

#Index files
for i in "${chrom_list[@]}"; do
    bcftools index $vcf_folder/repx/${i}_sites.vcf.gz; 
done

#Merge vcfs and then sort merged.vcf
cd $vcf_folder/repx
bcftools concat -Oz -o repx_merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o repx_merged_sorted.vcf.gz repx_merged.vcf.gz

#Rename chromosomes (required)
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/repx/gone_repx.vcf.gz $vcf_folder/repx/repx_merged_sorted.vcf.gz
 ```