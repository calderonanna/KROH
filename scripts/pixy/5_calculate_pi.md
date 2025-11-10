# Calculate Pi

```bash
salloc --nodes=1 --mem=100G --time=5:00:00 --account=open

# Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"


cd $pixy

echo -e "CHR\tSUM_PI\tCOUNT" > cKIWA_pi.txt 
for i in $(cat $scripts/autochrs.txt); do
    grep -v "NA" ${i}_pi.txt | awk -v chr="$i" 'NR>1 && $1=="cKIWA" {sum+=$5; count++} END {print chr, sum, count}' OFS="\t" >> cKIWA_pi.txt;
done

echo -e "CHR\tSUM_PI\tCOUNT" > hKIWA_pi.txt 
for i in $(cat $scripts/autochrs.txt); do
    grep -v "NA" ${i}_pi.txt | awk -v chr="$i" 'NR>1 && $1=="hKIWA" {sum+=$5; count++} END {print chr, sum, count}' OFS="\t" >> hKIWA_pi.txt;
done
```