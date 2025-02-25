# Run GONE

## Create bash script
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/run_gone.sh
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic

#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Run GONE
for i in $(seq 1 10); do
    cd $gone_folder
    bash script_GONE.sh gone_rep${i}
    cd $gone_folder
    mkdir gone_${i}00K
    mv OUTPUT_gone_rep${i} Output_Ne_gone_rep${i} Output_d2_gone_rep${i} TEMPORARY_FILES/ gone_rep${i}.map gone_rep${i}.ped outfileHWD seedfile timefile gone_${i}00K/
    mv $gone_folder/gone_${i}M/Output_Ne_gone $gone_folder/gone_${i}M/Output_Ne_gone_${i}M
    sed -i '1d' $gone_folder/gone_${i}M/Output_Ne_gone_${i}M;
done
```



