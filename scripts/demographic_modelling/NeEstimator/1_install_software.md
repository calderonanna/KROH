# Installation

## Download NeEstimator
https://github.com/bunop/NeEstimator2.X/issues/2
https://github.com/bunop/NeEstimator2.X/releases/tag/v2.0.1

```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"
cd $bin

#Download Linux Executable
wget https://github.com/bunop/NeEstimator2.X/releases/download/v2.0.1/Ne2L

#Change Permissions
chmod +x Ne2L
```

## PGDSpider
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"
cd $bin

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
