# Input Files

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

## Create .ped and .map 
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/map_ped.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=10:00:00
#SBATCH --account=open

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_rut"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

plink --vcf $vcf_folder/auto.100K.vcf.gz  --recode --allow-extra-chr --chr-set 30 --make-bed --out $gone_folder/100K

plink --vcf $vcf_folder/auto.8M.vcf.gz  --recode --allow-extra-chr --chr-set 30 --make-bed --out $gone_folder/8M

#Remove any unnessary files
cd $gone_folder
rm -rf *.nosex *.log *.fam *.bed *.bim

#Reformat .ped and .map
cd $gone_folder
awk '{$2="IND"NR; print}' OFS=" " 100K.ped > temp && mv -f temp 100K.ped
awk '{$1=1; print}' OFS=" " 100K.ped > temp && mv -f temp 100K.ped
awk '{print $1,$2="SNP"NR,$3,$4}' 100K.map > temp && mv -f temp 100K.map 

awk '{$2="IND"NR; print}' OFS=" " 8M.ped > temp && mv -f temp 8M.ped
awk '{$1=1; print}' OFS=" " 8M.ped > temp && mv -f temp 8M.ped
awk '{print $1,$2="SNP"NR,$3,$4}' 8M.map > temp && mv -f temp 8M.map 

#Merge .map files with HOSP.map
```