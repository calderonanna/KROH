## Input Files

`data.map` is a file with recombination rates with the following format: If you don't know the recombination rate, then you can leave this as 0. In the parameter file, we can change this by giving it an average recombination
rate to keep constant. 
|CHR|SNP |cM|POS  |
|---|----|--|-----|
|1  |SNP1|0 |4523 |
|1  |SNP2|0 |5625 |

`data.ped` is a pedigree file with genotype data. The genotype information has to include polymorphic data. I provided only monomorphic and it wouldn't allow for calculation of LD. Each line contains the genotype information for a single individual. Column 6 must have -9 for this to work. 
1 IND1 0 0 0 -9 A A T...
1 IND2 0 0 0 -9 A C G...
1 IND3 0 0 0 -9 A A G...

## Create .ped and .map file
```bash
#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf"

#Create .ped and .map
cd $gone_folder
for i in $(seq 1 10); do
    plink --vcf $vcf_folder/rep${i}/rep${i}_merged_sorted.vcf.gz --recode --allow-extra-chr --chr-set 30 --make-bed --out $gone_folder/gone_rep${i};
done

#Remove any unnessary files
rm -rf *.nosex *.log *.fam *.bed *.bim
```

## Reformat .ped and .map files
```bash
#Reformat .ped and .map files
cd $gone_folder

for i in $(seq 1 10); do
    awk '{$2="IND"NR; print}' OFS=" " gone_rep${i}.ped > temp_${i} && mv -f temp_${i} gone_rep${i}.ped
    awk '{$1=1; print}' OFS=" " gone_rep${i}.ped > temp_${i} && mv -f temp_${i} gone_rep${i}.ped
    awk '{print $1,$2="SNP"NR,$3,$4}' gone_rep${i}.map > temp_${i} && mv -f temp_${i} gone_rep${i}.map;
done
```