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
nano $scripts/rhino_trim.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=8GB
#SBATCH --time=40:00:00
#SBATCH --account=zps5164_sc_default
#SBATCH --job-name=rhino_trim
#SBATCH --error=/storage/group/zps5164/default/shared/rhinos/err/%x.%j.out

#Set Variables
scripts="/storage/group/zps5164/default/shared/rhinos/scripts"
ref="/storage/group/zps5164/default/shared/reference_genomes/black_rhino"
fastq="/storage/group/zps5164/default/shared/rhinos/fastq"
adapter_removal="/storage/home/abc6435/ToewsLab/bin/adapterremoval-2.1.7/build/AdapterRemoval"

set -ue

$adapter_removal \
    --file1 $fastq/BR18_R1.fastq.gz \
    --file2 $fastq/BR18_R2.fastq.gz \
    --collapse \
     --trimns \
    --minlength 20 \
    --qualitybase 33 \
    --gzip \
    --basename $fastq/BR18_trim
```

