# Adapter Removal 
https://adapterremoval.readthedocs.io/en/stable/manpage.html

`AdapterRemoval --file1 INPUT_R1.fastq --file2 INPUT_R2.fastq --file2 --collapse --trimns --minlength 20 --qualitybase 33 --basename filepath/OUTPUT_trim`

**--collapse**: collapses any regions where read 1 and read 2 overlap because the reads overlapped 
**--trimns**: trims any base that was called as 'N'.
**--minlength 20**: Filters out any reads less than 20bp
**--qualitybase 33**: The input file is in phred 33 quality score
**--gzip**: zip up the file
**--basename**: specify location and name to store trimmed reads 

```bash
for i in `cat $scripts/SETO_IDS.txt`; do 
    cat <<EOT > $scripts/trim_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=8GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=trim_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference"
fastq="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/fastq"
adapter_removal="/storage/home/abc6435/ToewsLab/bin/adapterremoval-2.1.7/build/AdapterRemoval"

set -ue
\$adapter_removal \\
    --file1 \$fastq/${i}_R1.fastq.gz \\
    --file2 \$fastq/${i}_R2.fastq.gz \\
    --collapse \\
    --trimns \\
    --minlength 20 \\
    --qualitybase 33 \\
    --gzip \\
    --basename \$fastq/${i}_trimmed
EOT
done

for i in `cat $scripts/SETO_IDS.txt`; do
    sbatch $scripts/trim_${i}.bash;
done
```

