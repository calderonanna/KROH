## Input Files

`data.map` is a file with recombination rates with the following format:
If you don't know the recombination rate, then you can leave this as a 0. 
In the parameter file, we can change this by giving it an average recombination
rate to keep constant. 
|CHR|SNP |cM|POS  |
|---|----|--|-----|
|1  |SNP1|0 |4523 |
|1  |SNP2|0 |5625 |

`data.ped` is a pedigree file with genotype data. The genotype information has to include polymorphic data.
I provided only monomorphic and it wouldn't allow for calculation of LD. Each line contains the genotype 
information for a single individual. Column 6 must have -9 for this to work. 
1 IND1 0 0 0 -9 A A T...
1 IND2 0 0 0 -9 A C G...
1 IND3 0 0 0 -9 A A G...


## Clean VCF
```bash
salloc --nodes=1 --ntasks=1 --mem=5G --time=02:00:00 --account=zps5164_sc

#Set Variables
VCF="/storage/home/abc6435/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono.vcf.gz"
VCF_SUB="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux/kirt_sub.vcf.gz"
VCF_SUB_NMISS="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux/kirt_sub_no_missing.vcf.gz"
RANDOM_SITES="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux/random_sites.txt"
RAND_VCF="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux/rand.vcf.gz"
GONE_VCF="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux/gone.vcf.gz"
GONE_FOLDER="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux"
CHROM_LIST="chr1,chr1a,chr2,chr3,chr4,chr4a,chr5,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr17,chr18,chr19,chr20,chr21,chr22,chr23,chr24,chr25,chr26,chr27,chr28,chr29"

#Extract autosomes and exclude missing data
bcftools view $VCF -r $CHROM_LIST -Oz -o $VCF_SUB
bcftools view -e 'GT="./."' $VCF_SUB -Oz -o $VCF_SUB_NMISS

#Randomly sample sites 
bcftools view -H $VCF_SUB_NMISS | shuf -n 1000000 | cut -f1,2 > $RANDOM_SITES
bcftools view -T $RANDOM_SITES -Oz -o $RAND_VCF $VCF_SUB_NMISS

#Rename chromosomes GONE does not accept unconvential names
bcftools query -f '%CHROM\n' $VCF | uniq > rename_chr.txt
awk '{print $1,$2="chr"NR}' OFS="\t" rename_chr.txt > temp && mv temp rename_chr.txt

bcftools annotate --rename-chrs rename_chr.txt -o $GONE_VCF $RAND_VCF
 ```

## Create .ped and .map file
```bash
#Create .ped and .map
cd $GONE_FOLDER
plink --vcf $GONE_VCF --recode --allow-extra-chr --chr-set 30 --make-bed --out gone
rm -rf *.nosex *.log *.fam *.bed *.bim *no_miss* *sub* *time* *seed* TEMPORARY_FILES/ *OUT* *out* *Out* *chrom* *param* *data*
```

## Obtain Chromosome Information
(Kawakami et al. 2014)
|Chr Size (Mb)|Recombination rate(cM/Mb)|
|--|--|
|>100|1.6|
|50-100|2.0|
|25-50|1.7|
|10-25|1.5|

```bash
#Obtain chromosome lengths
zgrep "##contig=<ID=chr" gone.vcf.gz >> chr_lengths.txt
sed -i 's/##contig=<ID=//g' chr_lengths.txt
sed -i 's/,length=/ /g' chr_lengths.txt
sed -i 's/>//g' chr_lengths.txt
awk '{print $1, $2=$2/1000000}' chr_lengths.txt > temp && mv temp chr_lengths.txt 

#Add recombination rate information (Kawakami et al.)
awk '{print $1=NR, $2}' chr_lengths.txt > temp && mv temp chr_lengths.txt
awk '{
    if ($2 > 100) $3 = 1.6;
    else if ($2 > 50 && $2 <= 100) $3 = 2.0;
    else if ($2 > 25 && $2 <= 50) $3 = 1.7;
    else if ($2 > 10 && $2 <= 25) $3 = 1.5;
    else ($3 = 1.5);
    print
}' chr_lengths.txt > temp && mv temp chr_lengths.txt
sed -i 31d chr_lengths.txt
sed -i 's/ /\t/g' chr_lengths.txt
```

## Reformat .ped and .map
```bash
#Reformat .ped 
awk '{$2="IND"NR; print}' OFS=" " gone.ped > temp && mv temp gone.ped
awk '{$1=1; print}' OFS=" " gone.ped > temp && mv temp gone.ped

#Reformat .map and add recombination rates
awk '{print $1,$2="SNP"NR,$3,$4}' gone.map > temp && mv temp gone.map

awk '{
    if ($1 == 1 || $1 == 3 || $1 == 4) $3 = 1.6;
    else if ($1 == 2 || $1 == 5 || $1 == 7) $3 = 2.0;
    else if ($1 == 6 || $1 >= 12 && $1 <= 30) $3 = 1.5;
    else ($3 = 1.7);
    print}' gone.map > temp && mv temp gone.map

#Double check recombination rates match
sed -i 's/ /\t/g' gone.map
cat gone.map | cut -f 1,3 | uniq
sed -i 's/\t/ /g' gone.map
```





## Generate some basic stats
```bash
#Count the number of positions in the ped file
sed -n '1p' gone.ped | sed -E 's/.*-9 //' | wc -w

#Count the number of positions in the map file
cut -f 1 gone.map | wc -l

#Count the number of SNPS per chromosome
cut -f 1 gone.map | grep 1 | wc -l
```