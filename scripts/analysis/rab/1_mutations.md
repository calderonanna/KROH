# Mutations

```bash
#Upload Files
scp /Users/abc6435/Desktop/KROH/data/rab/* abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rab

#Reformat
muts="deleterious lossoffunction nonsynonymous tolerated noncoding synonymous"
rab="/storage/group/zps5164/default/abc6435/KROH/data/rab"

for i in $muts; do 
    mv $rab/${i}.txt $rab/${i}.temp
    sed -i "s/CHROM/chromo/g" $rab/${i}.temp
    sed -i "s/POS/position/g" $rab/${i}.temp
    cut -f1,2 $rab/${i}.temp > $rab/${i}.txt
    rm -rf $rab/${i}.temp;
done
```