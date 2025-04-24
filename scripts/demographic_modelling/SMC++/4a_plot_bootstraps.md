# Plot Ne Estimates

```bash
#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"

for rep in $(seq 1 79); do 
    cd $work_dir/bootstrap_${rep}
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif smc++ plot plot.png -c -g 2 $work_dir/bootstrap_${rep}/model.final.json
    mv -f plot.csv plot_rep1.csv
    mv -f plot.png plot_rep1.png;
done

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap/bootstrap_1/plot* /Users/annamariacalderon/Desktop/KROH/data/smc++