# Clean VCF 
```bash
salloc --nodes=1 --ntasks=1 --mem=4GB --time=5:00:00 --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"
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