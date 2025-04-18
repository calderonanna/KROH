# Estimate Ne

## Run Estimate
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/smc++_estimate.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=9:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=smc++_estimate
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"

cd $work_dir
singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
    smc++ estimate 1.4e-9 \
    --polarization-error 0.5 \
    $work_dir/chr1_cKIWA.smc.gz \
    $work_dir/chr1a_cKIWA.smc.gz \
    $work_dir/chr2_cKIWA.smc.gz \
    $work_dir/chr3_cKIWA.smc.gz \
    $work_dir/chr4_cKIWA.smc.gz \
    $work_dir/chr4a_cKIWA.smc.gz \
    $work_dir/chr5_cKIWA.smc.gz \
    $work_dir/chr6_cKIWA.smc.gz \
    $work_dir/chr7_cKIWA.smc.gz \
    $work_dir/chr8_cKIWA.smc.gz \
    $work_dir/chr9_cKIWA.smc.gz \
    $work_dir/chr10_cKIWA.smc.gz \
    $work_dir/chr11_cKIWA.smc.gz \
    $work_dir/chr12_cKIWA.smc.gz \
    $work_dir/chr13_cKIWA.smc.gz \
    $work_dir/chr14_cKIWA.smc.gz \
    $work_dir/chr15_cKIWA.smc.gz \
    $work_dir/chr17_cKIWA.smc.gz \
    $work_dir/chr18_cKIWA.smc.gz \
    $work_dir/chr19_cKIWA.smc.gz \
    $work_dir/chr20_cKIWA.smc.gz \
    $work_dir/chr21_cKIWA.smc.gz \
    $work_dir/chr22_cKIWA.smc.gz \
    $work_dir/chr23_cKIWA.smc.gz \
    $work_dir/chr24_cKIWA.smc.gz \
    $work_dir/chr25_cKIWA.smc.gz \
    $work_dir/chr26_cKIWA.smc.gz \
    $work_dir/chr27_cKIWA.smc.gz \
    $work_dir/chr28_cKIWA.smc.gz \
    $work_dir/chr29_cKIWA.smc.gz \
    -o $work_dir/results 
```

## Bootstrapping 
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/smc++_bootstrap.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=smc++_bootstrap
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"

cd $work_dir
singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
    smc++ bootstrap $work_dir/results_cKIWA/model.final.json \
    --cores 8 --output $work_dir/results_cKIWA/bootsraps/
