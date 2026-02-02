# Test

```bash
nano $scripts/rec.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=50:00:00
#SBATCH --account=open
#SBATCH --partition=himem
#SBATCH --job-name=rec
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
slim="/storage/group/zps5164/default/bin/SLiM/build/slim"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"

#Run Simulation
/usr/bin/time -v $slim -p $scripts/rec.slim

