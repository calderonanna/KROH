# Run Replicates
```bash
#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

for i in {1..30}; do
    cp $scripts/add_R0.bash $scripts/add_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/add_R${i}.bash
    sbatch $scripts/add_R${i}.bash
done

for i in {1..30}; do
    cp $scripts/dom_R0.bash $scripts/dom_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/dom_R${i}.bash
    sbatch $scripts/dom_R${i}.bash
done

for i in {1..30}; do
    cp $scripts/rec_R0.bash $scripts/rec_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/rec_R${i}.bash
    sbatch $scripts/rec_R${i}.bash
done