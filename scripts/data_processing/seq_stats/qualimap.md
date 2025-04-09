# Qualimap

```bash
salloc --account=dut374_c -N 1 -n 4 --mem-per-cpu=5000 -t 3:00:00

#load modules
module use /storage/group/dut374/default/sw/modules
module load all

#Set Variables
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
samples="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts/KIWA_IDS.txt"

#Run qualimap
for i in `cat $samples`; do
    qualimap bamqc -bam $data/bam/${i}_marked.bam -outdir $data/seq_stats/${i}_qualimap;
done

rsync abc6435@submit.hpc.psu.edu:~/SzpiechLab/abc6435/KROH/data/seq_stats/29779_qualimap/images_qualimapReport/* ~/Desktop
```