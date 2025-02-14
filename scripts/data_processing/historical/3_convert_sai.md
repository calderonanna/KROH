# Convert sai to sam

```bash
#Set Variables

scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
for i in `cat $scripts_folder/hKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/bwa_sampe_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=bwa_sampe_${i}

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
mywa_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_ref/mywa_reference"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#sai to sam
/usr/bin/time -v bwa sampe -r "@RG\tID:${i}\tSM:${i}" \\
\$mywa_folder/mywagenomev2.1 \\
$data_folder/sai/${i}_R1.sai $data_folder/sai/${i}_R2.sai \\
\$data_folder/trim/${i}_R1_trimmed.fastq.gz \\
\$data_folder/trim/${i}_R2_trimmed.fastq.gz \\
> \$data_folder/sam/${i}.sam \\
2> \$err_folder/${i}_bwasampe.err

EOT
done

## Checking Alignment Stats
```bash
#Set Variable
sam_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/sam"
for i in $sam_folder/*.sam; do
    echo "$(basename ${i})" >> $sam_folder/alignment_stats.txt
    echo "----------------------" >> $sam_folder/alignment_stats.txt
    samtools flagstat ${i} >> $sam_folder/alignment_stats.txt
    echo " " >> $sam_folder/alignment_stats.txt
done
```