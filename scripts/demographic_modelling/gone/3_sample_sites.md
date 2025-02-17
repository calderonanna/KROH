# Randomly sample sites 
I will do this several times to create replicates and then run gone several times across these replicates. 

## Pick Chromosomes With Plenty SNPS
Since I'm going to sub-sample repeatedly, I wanted to pick chromosomes with plenty of snps. 
```bash
#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))

#Count Number of SNPs Per Chromosome
for i in "${chr_list[@]}"; do
    echo ${i} >> $vcf_folder/snps_per_site.txt
    bcftools view -H $vcf_folder/${i}.vcf.gz | wc -l >> $vcf_folder/snps_per_chr.txt;
done

#Remove chr22, 25, and 27-29 from analysis
nano $vcf_folder/rename_chr.txt
awk '{print $1,$2="chr"NR}' OFS="\t" $vcf_folder/rename_chr.txt > $vcf_folder/temp && mv -f $vcf_folder/temp $vcf_folder/rename_chr.txt
```

## Create Bash Script
Create several of these scripts for each replicate. Doing this manually because nested loops are ugly and confusing and I literally cannot right now. 
```bash
#Make replicate folders
for i in $(seq 1 10); do
    mkdir $vcf_folder/rep${i};
done

nano $scripts_folder/gone_vcf_repx.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))

#Randomly sample sites 
for i in "${chr_list[@]}"; do
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 100000 | cut -f1,2 > $vcf_folder/repx/${i}_sites.txt;
done

#Extract sites from vcf files
for i in "${chr_list[@]}"; do
    bcftools view -T $vcf_folder/repx/${i}_sites.txt -Oz -o $vcf_folder/repx/${i}_sites.vcf.gz $vcf_folder/${i}.vcf.gz;
done

#Index files
for i in "${chr_list[@]}"; do
    bcftools index $vcf_folder/repx/${i}_sites.vcf.gz; 
done

#Merge vcfs and then sort merged.vcf
cd $vcf_folder/repx
bcftools concat -Oz -o repx_merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o repx_merged_sorted.vcf.gz repx_merged.vcf.gz

#Rename chromosomes (required)
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/repx/gone_repx.vcf.gz $vcf_folder/repx/repx_merged_sorted.vcf.gz
 ```

## Copy and Modify Script
Create a script for each replicate 
```bash
for i in $(seq 1 10); do
    cp "$scripts_folder/gone_vcf_repx.bash" "$scripts_folder/gone_vcf_rep${i}.bash"
    sed -i "s/repx/rep${i}/g" $scripts_folder/gone_vcf_rep${i}.bash;
done

#Submit scripts
for i in $(seq 1 10); do
    sbatch $scripts_folder/gone_vcf_rep${i}.bash;
done
```