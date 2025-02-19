# Sample Chromosomes
GONE does not need all sites in a vcf to run (it actually might crash the program). In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome and no more than 10 Million SNPS genome-wide. 

## Split VCF by chromosomes
Note: You only have to do this step once.
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/split_vcf.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"

#Split VCF by CHR
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))

for i in "${chr_list[@]}"; do
    bcftools view $vcf_folder/auto_nmiss.vcf.gz -r ${i} -Oz -o $vcf_folder/${i}.vcf.gz; 
done
```

## Randomly sample sites 
I will do this several times to create replicates and then run gone several times across these replicates. 
```bash
#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Make replicate folders
for i in $(seq 1 10); do
    mkdir $vcf_folder/rep${i};
done

#Create Scripts
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
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))
n_sites=

#Randomly sample sites 
for i in "${chr_list[@]}"; do
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n $n_sites | cut -f1,2 > $vcf_folder/repx/${i}_sites.txt;
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
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -Oz -o $vcf_folder/repx/gone_repx.vcf.gz $vcf_folder/repx/repx_merged_sorted.vcf.gz
 ```

## Copy and Modify Script
Create a script for each replicate 
```bash
for i in $(seq 1 10); do
    cp "$scripts_folder/gone_vcf_repx.bash" "$scripts_folder/gone_vcf_rep${i}.bash"
    sed -i "s/repx/rep${i}/g" $scripts_folder/gone_vcf_rep${i}.bash
    sed -i "s/n_sites=/n_sites=${i}00000/g" $scripts_folder/gone_vcf_rep${i}.bash;
done

#Submit scripts
for i in $(seq 1 10); do
    sbatch $scripts_folder/gone_vcf_rep${i}.bash;
done
```