# Installation
https://github.com/popgenmethods/smcpp

SMC++ requires docker to run, which you can't do on a cluster. An alternative is to use `singularity` which is specifically for HPC and was already available to use in our cluster (yay)

## Convert Docker Image to .sif (singularity format)

```bash 
cd /storage/home/abc6435/SzpiechLab/bin

singularity pull smcpp.sif docker://terhorst/smcpp:latest

#make sure it works
bin="/storage/home/abc6435/SzpiechLab/bin"
singularity exec --bind $PWD:/mnt $bin/smcpp.sif smc++ --help


``