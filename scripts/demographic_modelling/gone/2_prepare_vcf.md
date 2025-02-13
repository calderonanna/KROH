## Prepare VCF File
GONE does not need all sites in a vcf to run (it actually might crash the program). In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome and no more than 10 Million SNPS genome-wide. 

## Obtain Clean VCF With Randomly Subsetted Sites
```bash
salloc --nodes=1 --ntasks=1 --mem=5G --time=07:00:00 --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
chrom_list="chr1,chr1a,chr2,chr3,chr4,chr4a,chr5,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr17,chr18,chr19,chr20,chr21,chr22,chr23,chr24,chr25,chr26,chr27,chr28,chr29"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Extract autosomes and exclude missing data
bcftools view $vcf -r $chrom_list -Oz -o $gone_folder/auto.vcf.gz
bcftools view -e 'GT="./."' $gone_folder/auto.vcf.gz -Oz -o $gone_folder/auto_nmiss.vcf.gz

#Randomly sample sites (~100K/chr)
bcftools view -H $gone_folder/auto_nmiss.vcf.gz | shuf -n 3000000 | cut -f1,2 > $gone_folder/sites.txt
bcftools view -T $gone_folder/sites.txt -Oz -o $gone_folder/auto_nmiss_rand.vcf.gz $gone_folder/auto_nmiss.vcf.gz

#Rename chromosomes (required)
if [ -e "$gone_folder/rename_chr.txt" ]; then
    bcftools query -f '%CHROM\n' "$vcf" | uniq > rename_chr.txt
    awk '{print $1,$2="chr"NR}' OFS="\t" rename_chr.txt > temp && mv -f temp rename_chr.txt
fi

bcftools annotate --rename-chrs rename_chr.txt -o $gone_folder/gone.vcf.gz $gone_folder/auto_nmiss_rand.vcf.gz
 ```