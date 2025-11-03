# Mutation Sites

```bash
#Upload Files
scp ~Desktop/KROH/data/rxy/* abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy

#Reformat
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous"
for i in $muts; do 
    mv $rxy/${i}.txt $rxy/${i}.temp
    sed -i "s/CHROM/chromo/g" $rxy/${i}.temp
    sed -i "s/POS/position/g" $rxy/${i}.temp
    cut -f1,2 $rxy/${i}.temp > $rxy/${i}.txt
    rm -rf $rxy/${i}.temp;
done
```