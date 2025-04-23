# Install Software


## RLDNe
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

cd $bin
git clone https://github.com/zakrobinson/RLDNe.git
cd $bin/RLDNe/inst/bin/linux
chmod +x Ne2-1L
```

## PGDSpider
https://software.bioinformatics.unibe.ch/pgdspider/PGDSpiderManual_v3-0-0-0.pdf
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

#Download 
wget https://software.bioinformatics.unibe.ch/pgdspider/PGDSpider_3.0.0.0.zip
unzip $bin/PGDSpider_3.0.0.0.zip

#Specify bcftools/samtools path
nano $bin/spider.conf.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
<entry key="PathBcftools">/storage/group/zps5164/default/bin/bcftools</entry>
<entry key="WindowWidth">1194</entry>
<entry key="Language">English</entry>
<entry key="PathSamtools">/storage/group/zps5164/default/bin/samtools</entry>
<entry key="Resizable">true</entry>
<entry key="WindowHeight">600</entry>
</properties>
```