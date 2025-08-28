## Modify Parameter File
I used the genome-wide average recombination rate from Passer domesticus recombination map from Hagen et al.2019 (DOI: 10.1111/1755-0998.13134). The Passeridae family is apparently closer to the Parulidae family than is the Muscicapidae (ficedulla albicollis) according to Stiller et al. 2024 (https://doi.org/10.1038/s41586-024-07323-1). 

Using Passer domesticus average recombination rate of 4.82cM/Mb resulted in more resonable Ne estimates than using the average genome-wide recombination rate of  3.1cM/Mb from Ficedulla albicollis. 

Kardos et al. 2020 also used pairs of loci within 2cM, assuming a 1cM/Mb genome-wide recombination rate, so they set they set hc=0.02 to reduce bias from population substructuring. 

```bash
#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

nano $gone_folder/INPUT_PARAMETERS_FILE
#INPUT_PARAMETERS_FILE

########################################################

PHASE=2 ### Phase = 0 (pseudohaploids), 1 (known phase), 2 (unknown phase)
cMMb=1  ### CentiMorgans per Megabase (if distance is not available in map file).
DIST=1  ### none (0), Haldane correction (1) or Kosambi correction (2)
NGEN=120 ### Number of generations for which linkage data is obtained in bins
NBIN=60  ### Number of bins (e.g. if 400, each bin includes NGEN/NBIN = 2000/400 = 5 generations)
MAF=0.0   ### Minor allele frequency (0-1) (recommended 0)
ZERO=0    ### 0: Remove SNPs with zeroes (1: allow for them)
maxNCHROM=-99  ### Maximum number of chromosomes to be analysed (-99 = all chromosomes; maximum number is 200)
maxNSNP=50000 ### Maximum approx number of SNPs per chromosomes to be analysed (maximum number is 50000)
hc=0.025   ### Maximum value of c analysed (recommended 0.05; maximum is 0.5)
REPS=40   ### Number of replicates to run GONE (recommended 40)
threads=-99  ### Number of threads (if -99 it uses all possible processors)

###################################################################
```


