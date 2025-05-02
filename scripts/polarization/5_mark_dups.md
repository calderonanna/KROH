# Mark Duplicated Reads

## Scripts
```bash
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

for i in `cat $scripts/GWBW_IDS.txt`; do 
    cat <<EOT > $scripts/mark_duplicates_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --job-name=mark_duplicates_${i}
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.log

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
picard_tools_folder="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8"

#Run Picard Tools
java -Xmx20g -jar \$picard_tools_folder/picard.jar MarkDuplicates INPUT=\$data/bam/${i}_sorted.bam OUTPUT=\$data/bam/${i}_marked.bam METRICS_FILE=\$data/bam/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000
EOT
done

#Submit each job
for i in `cat $scripts/GWBW_IDS.txt`; do 
    sbatch $scripts/mark_duplicates_${i}.bash;
done
```

