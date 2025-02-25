## Sample Sites Genome Wide 
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
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_rut"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Randomly sample sites 
bcftools view -H $vcf_folder/auto_nmiss.vcf.gz | shuf -n 4000000 | cut -f1,2 > $vcf_folder/auto_nmiss_4Msites.txt
bcftools view -H $vcf_folder/auto_nmiss.vcf.gz | shuf -n 6000000 | cut -f1,2 > $vcf_folder/auto_nmiss_6Msites.txt
bcftools view -H $vcf_folder/auto_nmiss.vcf.gz | shuf -n 8000000 | cut -f1,2 > $vcf_folder/auto_nmiss_8Msites.txt

#Extract sites from vcf file
bcftools view -T $vcf_folder/auto_nmiss_4Msites.txt -Oz -o $vcf_folder/auto_nmiss_4Msites.vcf.gz $vcf_folder/auto_nmiss.vcf.gz
bcftools view -T $vcf_folder/auto_nmiss_6Msites.txt -Oz -o $vcf_folder/auto_nmiss_6Msites.vcf.gz $vcf_folder/auto_nmiss.vcf.gz
bcftools view -T $vcf_folder/auto_nmiss_8Msites.txt -Oz -o $vcf_folder/auto_nmiss_8Msites.vcf.gz $vcf_folder/auto_nmiss.vcf.gz

#Index
bcftools index $vcf_folder/auto_nmiss_4Msites.vcf.gz
bcftools index $vcf_folder/auto_nmiss_6Msites.vcf.gz
bcftools index $vcf_folder/auto_nmiss_8Msites.vcf.gz

#Rename chromosomes (required)
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/gone_4M.vcf.gz $vcf_folder/auto_nmiss_4Msites.vcf.gz
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/gone_6M.vcf.gz $vcf_folder/auto_nmiss_6Msites.vcf.gz
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/gone_8M.vcf.gz $vcf_folder/auto_nmiss_8Msites.vcf.gz
 ```