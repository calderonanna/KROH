# Recent Demographic Inference with GONE
GONE is a tool for estimating effective population size (Ne) using temporal genetic data and linkage disequilibrium methods. 
Santiago et al. 2020 (doi:10.1093/molbev/ms aa16)

## Installation 
Install GONE from the git repository. 
```bash
cd ~/SzpiechLab/abc6435/KROH/data
git clone https://github.com/esrud/GONE.git
mv GONE/ gone/

#change permission
cd gone/Linux/PROGRAMMES
chmod +x GONE
chmod +x GONEaverage
chmod +x LD_SNP_REAL3
chmod +x MANAGE_CHROMOSOMES2
chmod +x SUMM_REP_CHROM3
chmod +x GONEparallel.sh

#remove any unnecessary folders and files
rm 'GONE TUTORIAL.pdf' README.md 'USER'$'\302\264''S GUIDE.pdf'
rm -rf MacOSX
rm -rf EXAMPLE
rm -rf CODES_LINUX CODES_MACOSX
```