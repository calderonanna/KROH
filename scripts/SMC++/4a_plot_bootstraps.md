# Plot Ne Estimates

```bash
#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"

for rep in $(seq 1 79); do 
    cd $work_dir/bootstrap_${rep}
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif smc++ plot plot.png -c -g 2 $work_dir/bootstrap_${rep}/model.final.json
    mv -f plot.csv plot_rep${rep}.csv
    mv -f plot.png plot_rep${rep}.png;
done

```

## Compile Datasets
```bash
bin="/storage/home/abc6435/SzpiechLab/bin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"

#Long Format
for i in $(seq 1 79); do 
    cd $work_dir/bootstrap_${i}
    #sed -i 's/,/\t/g' plot_rep${i}.csv
    #sed -i '1d' plot_rep${i}.csv
    awk -v i="${i}" '{print $1=NR, $2, $3, $4="rep_"i}' OFS='\t' \
        plot_rep${i}.csv >> $work_dir/bootstrap_results.txt;
done


rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap/bootstrap_results.txt /Users/abc6435/Desktop/KROH/data/smc++