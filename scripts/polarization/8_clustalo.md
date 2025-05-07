# Clustalo 

## Installation
```bash
bin="/storage/home/abc6435/SzpiechLab/bin"
cd $bin
wget http://www.clustal.org/omega/clustalo-1.2.4-Ubuntu-x86_64
mkdir clustalo 
mv clustalo-1.2.4-Ubuntu-x86_64 clustalo/
cd clustalo
chmod +x clustalo-1.2.4-Ubuntu-x86_64
```
## File Prep
```bash
#Set Variables
work="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/polar"
script="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Add sample ids to .fa files THIS WORKS
while read chr; do
    sed -i "s/>${chr}$/>${chr}_test/g" \
        $work/test.fa
done < $script/chrs.txt

    