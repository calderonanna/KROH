# Run GONE

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/run_gone.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=run_gone
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Setup
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Run GONE
for i in $(seq 1 100); do
    cd $gone_folder
    bash script_GONE.sh R${i}
    sed -i '1d' Output_Ne_R${i}
    mkdir $gone_folder/results/R${i}
    mv OUTPUT_R${i} Output_Ne_R${i} R${i}.map Output_d2_R${i} R${i}.ped outfileHWD seedfile timefile TEMPORARY_FILES/ $gone_folder/results/R${i};
done
```

## Compile Results

```bash
gone="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
mkdir $gone/results/Ne

for i in $(seq 1 100); do
    cp $gone/results/R${i}/Output_Ne_R${i} $gone/results/Ne; 
done
```