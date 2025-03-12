# Run GONE

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/run_gone.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=200:00:00
#SBATCH --account=dut374_c
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Setup
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Run GONE
for i in $(seq 10 300); do
    cd $gone_folder
    bash script_GONE.sh R${i}
    sed -i '1d' Output_Ne_R${i}
    mkdir $gone_folder/results/R${i}
    mv *R${i}* outfileHWD seedfile timefile TEMPORARY_FILES/ $gone_folder/results/R${i};
done
```

