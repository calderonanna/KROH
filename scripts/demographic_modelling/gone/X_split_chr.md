# Prepare VCF Files for Demographic Modelling
Following Santiago et al. 2020 (oi:10.1093/molbev/ms aa169), the Finnish example in Fig3: given the availability of SNPs, I sampled 50K random sites from each chromosome. I ran multiple replicates (e.g, 20) using these replicates give a 90% CI. 

```bash
salloc --nodes=1 --ntasks=1 --mem=5G --time=07:00:00 --account=open

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Filter out missing genotypes, then index
bcftools view -e 'GT="./."' $vcf -Oz -o $gone_folder/no_miss.vcf.gz
bcftools index $gone_folder/no_miss.vcf.gz

#Split vcf by chr
CHROM_LIST=(chr1 chr1a chr2 chr3 chr4 chr4a chr5 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr17 chr18 chr19 chr20 chr21 chr22 chr23 chr24 chr25 chr26 chr27 chr28 chr29)

for i in "${CHROM_LIST[@]}"; do
    bcftools view $gone_folder/no_miss.vcf.gz -r ${i} -Oz -o $gone_folder/${i}.vcf.gz; 
done

#Randomly sample sites 
for i in "${CHROM_LIST[@]}"; do
    bcftools view -H $gone_folder/${i}.vcf.gz | shuf -n 50000 | cut -f1,2 > $gone_folder/${i}_random_sites.txt; 
done

#Extract Sites from vcf files
for i in "${CHROM_LIST[@]}"; do
    bcftools view -T $gone_folder/${i}_random_sites.txt -Oz -o $gone_folder/${i}_random_sites.vcf.gz $gone_folder/${i}.vcf.gz;
done

#Index files
for i in "${CHROM_LIST[@]}"; do
    bcftools index ${i}_random_sites.vcf.gz; 
done

#Merge vcfs and then sort merged.vcf
cd $gone_folder
VCF_LIST=(*_random_sites.vcf.gz)
bcftools concat -Oz -o merged.vcf.gz *_random_sites.vcf.gz

bcftools sort -Oz -o merged_sorted.vcf.gz merged.vcf.gz

#Rename chromosomes (required)
if [ -e "$gone_folder/rename_chr.txt" ]; then
    bcftools query -f '%CHROM\n' "$vcf" | uniq > rename_chr.txt
    awk '{print $1,$2="chr"NR}' OFS="\t" rename_chr.txt > temp && mv -f temp rename_chr.txt
fi

bcftools annotate --rename-chrs rename_chr.txt -o $gone_folder/gone_rep1.vcf.gz $gone_folder/merged_sorted.vcf.gz
 ```