## Modify Parameter File
```bash
#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"

nano $data_folder/gone/Linux/INPUT_PARAMETERS_FILE
#INPUT_PARAMETERS_FILE
########################################################
PHASE=2 ### Phase = 0 (pseudohaploids), 1 (known phase), 2 (unknown phase)
cMMb=1 ### CentiMorgans per Megabase (if distance is not available).
DIST=1 ### none (0), Haldane correction (1) or Kosambi correction (2)
NGEN=2000 ### Number of generations for which linkage data is obtained in bins
NBIN=400 ### Number of bins (so that each bin includes NGEN/NBIN generations)
MAF=0.0 ### Minimum allele frequency (0-1)
ZERO=1 ### 0: Remove SNPs with zeroes (1: allow for them)
maxNCHROM=-99 ### Maximum number of chromosomes to be analysed (-99 = all chrom
osomes; maximum number is 200)
maxNSNP=50000 ### Maximum approx number of SNPs per chromosomes to be analysed
hc=0.05 ### Maximum value of c analysed
REPS=40 ### Number of GONE internal replicates
threads=-99 ### Number of threads (if -99 it uses all possible processors)
###################################################################
```


