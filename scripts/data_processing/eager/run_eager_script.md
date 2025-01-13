# Run EAGER As A Job

```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/test_eager.bash
#-----------------NANO---------------
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=test_eager_pipeline
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.err
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

cd /storage/home/abc6435/SzpiechLab/abc6435/KROH/eager_src
./eager_script_R_KIWA_NextSeq2000_WGS__30bp_q30Q30.sh
#-----------------EOS---------------

#submit Job
sbatch $scripts_folder/test_eager.bash
```