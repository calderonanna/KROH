# QC Filtering 

## hKIWA
```bash
nano $scripts/rohan_qc_hKIWA.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=24:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=rohan_qc
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"

for i in $(cat $scripts/hKIWA_IDS_e759877.txt); do
    samtools view -b -F 0x200 $bam/${i}_sorted_marked.rescaled.bam \
    | samtools sort -o $bam/${i}_sorted_marked_rescaled_qc.bam 
    samtools index $bam/${i}_sorted_marked_rescaled_qc.bam;
done
```

## cKIWA
```bash
nano $scripts/rohan_qc_cKIWA.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=24:00:00
#SBATCH --account=open
#SBATCH --partition=standard
#SBATCH --job-name=rohan_qc
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"

for i in $(cat $scripts/cKIWA_IDS.txt); do
    samtools view -b -F 0x200 $bam/${i}_sorted_marked_down.rescaled.bam \
    | samtools sort -o $bam/${i}_sorted_marked_down_rescaled_qc.bam 
    samtools index $bam/${i}_sorted_marked_down_rescaled_qc.bam;
done
```
