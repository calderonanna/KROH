```bash
nano $scripts/reads.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=8GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=reads
#SBATCH --error=/storage/home/abc6435/ToewsLab/helaina/job_err_out/%x.%j.out

#Set Variables
fastq='/storage/group/dut374/default/helaina/data/fastq'
scripts='/storage/home/abc6435/ToewsLab/helaina/scripts'
seq_stats='/storage/home/abc6435/ToewsLab/helaina/data/seq_stats'

for i in $(cat $scripts/ids.txt); do
    echo -e "${i}\t$(wc -l < $fastq/${i}_R1_001.fastq.gz)" \
        >> $seq_stats/reads.temp;
done
awk '{print $1, $2/4}' OFS="\t" $seq_stats/reads.temp >> $seq_stats/reads.txt
