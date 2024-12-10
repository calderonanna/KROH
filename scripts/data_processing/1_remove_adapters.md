# Adapter Removal using fastp
https://github.com/OpenGene/fastp

Not using adapterremoval because it creates a seperate file for unpaired reads making it really difficult to work with BWA. 

`fastp -i R1.fastq.gz -I R2.fastq.gz -o out.R1.fq.gz -O out.R2.fq.gz`
 
## Installation
```bash
#Install to bin
cd /storage/home/abc6435/SzpiechLab/bin
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp

#Add fastp to your $PATH and then add it permanently to bashrc
export PATH=/storage/home/abc6435/SzpiechLab/bin/fastp:$PATH
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/fastp:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## File Prep
```bash
#Moving some fastqs around
for i in `cat ~/SzpiechLab/abc6435/KROH/scripts/cKIWA_IDS.txt`; do
    mv ~/SzpiechLab/abc6435/WarblerROH/${i}/fastq/${i}_* /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/fastq
done

```
##  fastp script
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Make a trim folder
if [ ! -d "$data_folder/trim" ]; then
    mkdir -p "$data_folder/trim"
fi

#Run loop
for i in `cat $scripts_folder/KIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/trim_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=trim_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run fastp
fastp -i \$data_folder/fastq/${i}_R1.fastq.gz -I \$data_folder/fastq/${i}_R2.fastq.gz -o \$data_folder/trim/${i}_R1_trimmed.fastq.gz -O \$data_folder/trim/${i}_R2_trimmed.fastq.gz
EOT
done

#submit jobs
for i in $scripts_folder/trim_*.bash; do
    sbatch ${i}
done
```