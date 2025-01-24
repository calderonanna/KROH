## Input Files
`data.map` is a file with recombination rates with the following format:
If you don't know the recombination rate, then you can leave this as a 0. 
In the parameter file, we can change this by giving it an average recombination
rate to keep constant. See https://raw.githubusercontent.com/esrud/GONE/refs/heads/master/EXAMPLE/example.map

|CHR|SNP |cM|POS  |
|---|----|--|-----|
|1  |SNP1|0 |4523 |
|1  |SNP2|0 |5625 |

## Generate Input Files
```bash
#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#create a .map and .ped file
zcat ~/SzpiechLab/abc6435/WROH/data/vcf/kirtlandii_filtered_isec_nomono_monomorphic.vcf.gz | head -7000 > $data_folder/gone/Linux/test.vcf 

plink --vcf test.vcf --recode --out test

#delete these unnecessary files
rm test.nosex test.log
```