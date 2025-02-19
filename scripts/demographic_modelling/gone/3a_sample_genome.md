## Sample Sites Genome Wide 
Sample 2 million sites for the entire genome

```bash
salloc --nodes=1 --ntasks=1 --mem=4GB --time=5:00:00 --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Randomly sample sites 
bcftools view -H $vcf_folder/auto_nmiss.vcf.gz | shuf -n 3000000 | cut -f1,2 > $vcf_folder/auto_nmiss_sites.txt

#Extract sites from vcf file
bcftools view -T $vcf_folder/auto_nmiss_sites.txt -Oz -o $vcf_folder/auto_nmiss_sites.vcf.gz $vcf_folder/auto_nmiss.vcf.gz

#Index
bcftools index $vcf_folder/auto_nmiss_sites.vcf.gz

#Rename chromosomes (required)
bcftools annotate --rename-chrs $vcf_folder/rename_chr.txt -o $vcf_folder/gone.vcf.gz $vcf_folder/auto_nmiss_sites.vcf.gz
 ```