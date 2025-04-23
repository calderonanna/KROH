# Estimate Ne

## Run Estimate
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/smc++_estimate_bootstraps.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=10:00:00
#SBATCH --account=open
#SBATCH --job-name=smc++_estimate_bootstraps
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"

for rep in $(seq 54 80); do 
    cd $work_dir
    mkdir $work_dir/bootstrap_${rep}
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
        smc++ estimate 1.4e-9 \
        --polarization-error 0.5 \
        $work_dir/bootstrap_${rep}_chr1.smc.gz \
        $work_dir/bootstrap_${rep}_chr1a.smc.gz \
        $work_dir/bootstrap_${rep}_chr2.smc.gz \
        $work_dir/bootstrap_${rep}_chr3.smc.gz \
        $work_dir/bootstrap_${rep}_chr4.smc.gz \
        $work_dir/bootstrap_${rep}_chr4a.smc.gz \
        $work_dir/bootstrap_${rep}_chr5.smc.gz \
        $work_dir/bootstrap_${rep}_chr6.smc.gz \
        $work_dir/bootstrap_${rep}_chr7.smc.gz \
        $work_dir/bootstrap_${rep}_chr8.smc.gz \
        $work_dir/bootstrap_${rep}_chr9.smc.gz \
        $work_dir/bootstrap_${rep}_chr10.smc.gz \
        $work_dir/bootstrap_${rep}_chr11.smc.gz \
        $work_dir/bootstrap_${rep}_chr12.smc.gz \
        $work_dir/bootstrap_${rep}_chr13.smc.gz \
        $work_dir/bootstrap_${rep}_chr14.smc.gz \
        $work_dir/bootstrap_${rep}_chr15.smc.gz \
        $work_dir/bootstrap_${rep}_chr17.smc.gz \
        $work_dir/bootstrap_${rep}_chr18.smc.gz \
        $work_dir/bootstrap_${rep}_chr19.smc.gz \
        $work_dir/bootstrap_${rep}_chr20.smc.gz \
        $work_dir/bootstrap_${rep}_chr21.smc.gz \
        $work_dir/bootstrap_${rep}_chr22.smc.gz \
        $work_dir/bootstrap_${rep}_chr23.smc.gz \
        $work_dir/bootstrap_${rep}_chr24.smc.gz \
        $work_dir/bootstrap_${rep}_chr25.smc.gz \
        $work_dir/bootstrap_${rep}_chr26.smc.gz \
        $work_dir/bootstrap_${rep}_chr27.smc.gz \
        $work_dir/bootstrap_${rep}_chr28.smc.gz \
        $work_dir/bootstrap_${rep}_chr29.smc.gz \
        -o $work_dir/bootstrap_${rep}
    mv $work_dir/iterate.dat $work_dir/bootstrap_${rep};
done
```