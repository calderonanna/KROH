# Plot Ne Estimates

```bash
#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"

cd $work_dir
singularity exec --bind $PWD:/mnt $bin/smcpp.sif smc++ plot plot.png -c -g 2 $work_dir/results_cKIWA/model.final.json

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap/bootstrap_1/plot* /Users/annamariacalderon/Desktop/KROH/data/smc++