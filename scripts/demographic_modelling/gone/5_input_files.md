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
nano $scripts_folder/map_ped_R0.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=1:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic
#SBATCH --job-name=map_ped_R0
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

plink --vcf $vcf_folder/R0.vcf  --recode --allow-extra-chr --chr-set 29 --make-bed --out $gone_folder/R0

#Remove any unnessary files
cd $gone_folder
rm -rf R0.nosex R0.log R0.fam R0.bed R0.bim

#Reformat .ped
cd $gone_folder
awk '{$2="IND"NR; print}' OFS=" " R0.ped > temp_R0 && mv -f temp_R0 R0.ped
awk '{$1=1; print}' OFS=" " R0.ped > temp_R0 && mv -f temp_R0 R0.ped

#Reformat .map
awk 'BEGIN {OFS="\t"} {print "CHR"$1, $2, $3, $4, $1"_"$4}' R0.map > temp_R0 && mv -f temp_R0 R0.map

awk 'NR==FNR{a[$5]=$3; next} $5 in a {print $1, $2, a[$5], $4}' gone.map R0.map > temp_R0 && mv -f temp_R0 R0.map

sed -i 's/ /\t/g' R0.map
sed -i 's/\bCHR0\b/1/g' R0.map
sed -i 's/\bCHR1\b/2/g' R0.map
sed -i 's/\bCHR2\b/3/g' R0.map
sed -i 's/\bCHR3\b/4/g' R0.map
sed -i 's/\bCHR4\b/5/g' R0.map
sed -i 's/\bCHR5\b/6/g' R0.map
sed -i 's/\bCHR6\b/7/g' R0.map
sed -i 's/\bCHR7\b/8/g' R0.map
sed -i 's/\bCHR8\b/9/g' R0.map
sed -i 's/\bCHR9\b/10/g' R0.map
sed -i 's/\bCHR10\b/11/g' R0.map
sed -i 's/\bCHR11\b/12/g' R0.map
sed -i 's/\bCHR12\b/13/g' R0.map
sed -i 's/\bCHR13\b/14/g' R0.map
sed -i 's/\bCHR14\b/15/g' R0.map
sed -i 's/\bCHR15\b/16/g' R0.map
sed -i 's/\bCHR17\b/17/g' R0.map
sed -i 's/\bCHR18\b/18/g' R0.map
sed -i 's/\bCHR19\b/19/g' R0.map
sed -i 's/\bCHR20\b/20/g' R0.map
sed -i 's/\bCHR21\b/21/g' R0.map
sed -i 's/\bCHR22\b/22/g' R0.map
sed -i 's/\bCHR23\b/23/g' R0.map
sed -i 's/\bCHR24\b/24/g' R0.map
sed -i 's/\bCHR25\b/25/g' R0.map
sed -i 's/\bCHR26\b/26/g' R0.map
sed -i 's/\bCHR27\b/27/g' R0.map
sed -i 's/\bCHR28\b/28/g' R0.map
sed -i 's/\bCHR29\b/29/g' R0.map

awk 'BEGIN {OFS="\t"} {print $1, $2="SNP"NR, $3, $4}' R0.map > temp_R0 && mv -f temp_R0 R0.map
```

## Replicate Script
```bash
for i in $(seq 11 20); do
    rm -rf $scripts_folder/map_ped_R${i}.bash
    cp $scripts_folder/map_ped_R0.bash $scripts_folder/map_ped_R${i}.bash
    sed -i "s/\bR0\b/R${i}/g" $scripts_folder/map_ped_R${i}.bash
    sed -i "s/temp_R0/temp_R${i}/g" $scripts_folder/map_ped_R${i}.bash
    sed -i "s/#SBATCH --job-name=map_ped_R0/#SBATCH --job-name=map_ped_R${i}/g" $scripts_folder/map_ped_R${i}.bash
    sbatch $scripts_folder/map_ped_R${i}.bash;
done
```