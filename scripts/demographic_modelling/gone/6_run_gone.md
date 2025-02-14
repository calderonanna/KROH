# Run GONE

## Create bash script
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/run_gone.sh
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --mem=10GB
#SBATCH --cpus-per-task=20
#SBATCH --account=zps5164_sc
#SBATCH --job-name=run_gone
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err

#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Run GONE
cd $gone_folder
bash script_GONE.sh gone
```




