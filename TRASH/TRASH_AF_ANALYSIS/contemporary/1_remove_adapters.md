# Adapter Removal using fastp
https://github.com/OpenGene/fastp

Not using adapterremoval because it creates a seperate file for unpaired reads making it really difficult to work with BWA. 

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

mv /storage/home/abc6435/SzpiechLab/abc6435/WROH/data/fastq/* /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/fastq

```

## Create Scripts
`fastp -i R1.fastq.gz -I R2.fastq.gz -o out.R1.fq.gz -O out.R2.fq.gz`
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Make a trim folder
if [ ! -d "$data_folder/trim" ]; then
    mkdir -p "$data_folder/trim"
fi

#Run loop
for i in `cat $scripts_folder/IDS.txt`; do 
    cat <<EOT > $scripts_folder/trim_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=3:00:00
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

#Submit Jobs
for i in `cat $scripts_folder/HOWA_AMRE_IDS.txt`; do 
    sbatch $scripts_folder/trim_${i}.bash;
done
```

## Error Output
Just making sure jobs were not killed due to insufficient memory
```bash
ls -lhat trim*err* | grep "Apr" | awk '{print $9}' | xargs grep "OOM"
```