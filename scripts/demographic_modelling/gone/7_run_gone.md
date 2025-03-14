# Run GONE

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/run_gone.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=6:00:00
#SBATCH --account=dut374_c
#SBATCH --job-name=run_gone
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Setup
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Run GONE
for i in $(seq 11 20); do
    cd $gone_folder
    bash script_GONE.sh R${i}
    sed -i '1d' Output_Ne_R${i}
    mkdir $gone_folder/results/R${i}
    mv OUTPUT_R${i} Output_Ne_R${i} R${i}.map Output_d2_R${i} R${i}.ped outfileHWD seedfile timefile TEMPORARY_FILES/ $gone_folder/results/R${i};
done
```

## For hc testing
```bash
for i in $(seq 0 2); do
    cd $gone_folder/results/R${i}
    mv R${i}.map R${i}.ped $gone_folder
    rm -rf $gone_folder/results/R${i}; 
done


rm -rf *chrom* TEMPORARY_FILES/ out* param* seedfile timefile data.*
``