## Run GARLIC
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"

#run 
garlic --auto-winsize --overlap-frac 0.05 --max-gap 1000000 --winsize 100 --tped-missing 0 --tped $work/KIWA.tped --tfam $work/KIWA.tfam --tgls $work/KIWA.tgls --gl-type GQ --resample 100 --centromere $work/centromere.txt --size-bounds 1000000 2000000 3000000 4000000 5000000 --out $work/KIWA
```