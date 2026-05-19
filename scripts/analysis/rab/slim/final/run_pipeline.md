# Run Replicates

```bash
#Set Variables
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
results="/storage/group/zps5164/default/abc6435/KROH/data/slim/vcf/results"

#Remove Old Slim Scripts
#rm -rf $scripts/*.slim

#Remove Old Results
#rm -rf $results/*.out $results/*.txt

#Remove Old Logs
rm -rf /storage/group/zps5164/default/abc6435/KROH/err/add_*
rm -rf /storage/group/zps5164/default/abc6435/KROH/err/dom_*
rm -rf /storage/group/zps5164/default/abc6435/KROH/err/rec_*

#Remove Old Scripts
for i in {1..300}; do
    rm -rf $scripts/add_R${i}.*
    rm -rf $scripts/dom_R${i}.*
    rm -rf $scripts/rec_R${i}.*
done

#Create and Submit New Scripts
for i in {1..300}; do 
    cp $scripts/add_R0.bash $scripts/add_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/add_R${i}.bash

    cp $scripts/dom_R0.bash $scripts/dom_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/dom_R${i}.bash

    cp $scripts/rec_R0.bash $scripts/rec_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts/rec_R${i}.bash

    sbatch $scripts/dom_R${i}.bash
    sbatch $scripts/add_R${i}.bash
    sbatch $scripts/rec_R${i}.bash
done