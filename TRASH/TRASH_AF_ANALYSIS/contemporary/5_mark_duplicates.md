# Marking Duplicated Reads In Sorted BAM Files
`java -Xmx[ng] -jar picard.jar MarkDuplicates I=input.bam O=marked_duplicates.bam M=marked_dup_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000`

- `-Xmx[ng]`: Memory where n is the number of gigabytes. Must match PBS/SLURM header and if you don't give it sufficient memory, it will kill your job. 
- `I`:One or more input SAM or BAM files to analyze. Must be coordinate sorted. Default value: null. This option may be specified 0 or more times.
- `O`: The output file to write marked records to Required.
- `METRICS_FILE`: File to write duplication metrics required.
- `MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000``: Maximum number of file handles to keep open when spilling read ends to disk. Set this number a little lower than the per-process maximum number of file that may be open. This number can be found by executing the 'ulimit -n' command on a Unix system. Default value: 8000. This option can be set to 'null' to clear the default value. 

Note: When I ran this, it took about 25-40 minutes and a total memory of 16GB. 
## Create Scripts
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

#Run Loop
for i in `cat $scripts_folder/HOWA_AMRE_IDS.txt`; do
    cat<<EOT > $scripts_folder/mark_duplicates_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=mark_duplicates_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
picard_tools_folder="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8"

#Run Picard Tools
java -Xmx20g -jar \$picard_tools_folder/picard.jar MarkDuplicates INPUT=\$data_folder/bam/${i}_sorted.bam OUTPUT=\$data_folder/bam/${i}_marked.bam METRICS_FILE=\$data_folder/bam/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000
EOT
done

#Submit each job
for i in `cat $scripts_folder/HOWA_AMRE_IDS.txt`; do
    sbatch $scripts_folder/mark_duplicates_${i}.bash
done

#Check Job Status
squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R" -u abc6435
```
