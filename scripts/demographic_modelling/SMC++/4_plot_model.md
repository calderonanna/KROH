# Plot Ne Estimates

```bash
#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"

cd $work_dir
singularity exec --bind $PWD:/mnt $bin/smcpp.sif smc++ plot plot.png -c -g 2 $work_dir/results/model.final.json

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/plot.png /Users/annamariacalderon/Desktop