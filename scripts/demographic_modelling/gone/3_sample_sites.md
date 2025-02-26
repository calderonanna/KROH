# Sample Sites 

## Genome-Wide
Here I define a number of SNPS to sample genome-wide. In the github issues, Armando recommends to have no more than 10 Million SNPS genome-wide. 

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/gone_sample_sites_rut.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt/auto"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Randomly sample sites 
bcftools view -H $vcf.vcf.gz | shuf -n 8000000 | cut -f1,2 > $vcf_folder/8M_sites.txt

#Extract sites from vcf file
bcftools view -T $vcf_folder/8M_sites.txt -Oz -o $vcf.8M.vcf.gz $vcf.vcf.gz

#Index
bcftools index $vcf.8M.vcf.gz

#Rename chromosomes (required)
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf.8M.gone.vcf.gz $vcf.8M.vcf.gz
 ```

## Per Chromosome
GONE does not need all sites in a vcf to run. In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome. 

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/sample_vcf_rut.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt/auto"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))

#Split VCF by CHR and sample sites
for i in "${chr_list[@]}"; do
    bcftools view $vcf.vcf.gz -r ${i} -Oz -o $vcf_folder/${i}.vcf.gz
    bcftools view -H $vcf_folder/${i}.vcf.gz | shuf -n 100000 | cut -f1,2 > $vcf_folder/${i}_100K_sites.txt
done

#Extract sites and index
for i in "${chr_list[@]}"; do
    bcftools view -T $vcf_folder/${i}_100K_sites.txt -Oz -o $vcf_folder/${i}_100K_sites.vcf.gz $vcf_folder/${i}.vcf.gz
    bcftools index $vcf_folder/${i}_sites.vcf.gz
done

#Merge, sort, and rename 
cd $vcf_folder
bcftools concat -Oz -o merged.vcf.gz *_sites.vcf.gz
bcftools sort -Oz -o merged_sorted.vcf.gz merged.vcf.gz
bcftools annotate --rename-chrs rename_chr.txt -Oz -o auto.100K.vcf.gz merged_sorted.vcf.gz
 ```