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

#Create .ped and .map
cd $gone_folder
plink --vcf $gone_folder/gone.vcf.gz --recode --allow-extra-chr --chr-set 29 --make-bed --out gone

#Remove any unnessary files
rm -rf *.nosex *.log *.fam *.bed *.bim *chrom* *param* *data*
```

## Reformat .ped and .map
```bash
cd $gone_folder

#Reformat .ped 
awk '{$2="IND"NR; print}' OFS=" " gone.ped > temp && mv -f temp gone.ped
awk '{$1=1; print}' OFS=" " gone.ped > temp && mv -f temp gone.ped

#Reformat .map and add recombination rates
awk '{print $1,$2="SNP"NR,$3,$4}' gone.map > temp && mv -f temp gone.map
```