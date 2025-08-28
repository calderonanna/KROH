# Convert SAM files to BAM Files 
http://quinlanlab.org/tutorials/samtools/samtools.html#converting-sam-to-bam-with-samtools-view

`samtools view -S -b sample.sam > sample.bam`
- `-S`: specifies that the input file is a sam file
- `-b`: species that we want to produce a bam file
- `>`: denotes where to store the output bam file.


## Create Scripts
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Make a bam folder
if [ ! -d "$data_folder/bam" ]; then
    mkdir -p "$data_folder/bam"
fi

#Run loop
for i in `cat $scripts_folder/HOWA_AMRE_IDS.txt`; do 
    cat <<EOT > $scripts_folder/sam_to_bam_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=sam_to_bam_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run samtools
samtools view -S -b $data_folder/sam/${i}.sam > $data_folder/bam/${i}.bam
EOT
done

#Submit each script and check job
for i in `cat $scripts_folder/HOWA_AMRE_IDS.txt`; do
    sbatch $scripts_folder/sam_to_bam_${i}.bash
done

#Check Job Status
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```

