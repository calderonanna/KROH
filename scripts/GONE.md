# Recent Demographic Inference with GONE
GONE is a tool for estimating effective population size (Ne) using temporal genetic data and linkage disequilibrium methods. 

## Installation 
Install GONE from the git repository. 
```bash
cd ~/SzpiechLab/bin
git clone https://github.com/esrud/GONE.git

#change permissions using chmod 
#change mode add executable permission
cd ~/SzpiechLab/bin/gone/Linux/PROGRAMMES
chmod +x GONE
chmod +x GONEaverage
chmod +x LD_SNP_REAL3
chmod +x MANAGE_CHROMOSOMES2
chmod +x SUMM_REP_CHROM3
```

## Input Files
`data.map` is a file with recombination rates with the following format:
If you don't know the recombination rate, then you can leave this as a 0. 
In the parameter file, we can change this by giving it an average recombination
rate to keep constant. 
|Chromosome|SNP       |cM        |POS       |
|----------|----------|----------|----------|
|1         |4523      |0         |4523  
|1         |56256     |0         |56256  

```bash
#Create a data.map file using vcf

```

