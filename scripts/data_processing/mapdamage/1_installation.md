# Installation MapDamage
I followed the regular installation steps found here 
https://ginolhac.github.io/mapDamage/

## Install Python Packages 
```bash
#install pysam
pip install pysam
```
## Install gsl Libraries
```bash
#search if package is installed
dpkg -l | egrep 'libgsl-dev'

#If not already installed
conda install conda-forge::gsl
```
## Load R Module
When installing, choose option 70 or 71. Installation of these packages only needs to be done once
```bash
#Install all Necessary Packages 
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0
```
## Install R Packages
```R
Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('RcppGSL', lib='/storage/group/zps5164/default/bin/.R')"

install.packages('inline', lib='/storage/group/zps5164/default/bin/.R')
install.packages('gam', lib='/storage/group/zps5164/default/bin/.R')
install.packages('Rcpp', lib='/storage/group/zps5164/default/bin/.R')
install.packages("RcppGSL",lib='/storage/group/zps5164/default/bin/.R')

q()
```