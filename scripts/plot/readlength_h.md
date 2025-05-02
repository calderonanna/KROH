# Plot Readlength Distributions

## Load R Module and Install Packages
```bash
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('ggplot2', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('tidyverse', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('ggpubr', dependencies=TRUE, lib='/storage/group/zps5164/default/bin/.R')"

```

## Create R Script
```R
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/plots/plot_readlengths_h.R

#!/usr/bin/env Rscript

# CALL PACKAGES
library(ggpubr, lib.loc='/storage/group/zps5164/default/bin/.R')
library(ggplot2, lib.loc='/storage/group/zps5164/default/bin/.R')
library(tidyverse, lib.loc='/storage/group/zps5164/default/bin/.R')

# IMPORT DATA
ids <- c(29779, 383194, 383202,
         383205,507264, 507265, 759877)

base_path <- "/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seq_stats/"

readlengths <- lapply(ids, function(id) {
    read.delim(paste0(base_path, id, "_readlength.txt"), header = FALSE)
})

names(readlengths) <- paste0("readlength_", ids)

# PLOT DATA
RL_29779 <- ggplot(readlengths$readlength_29779, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 29779")) + 
 theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

RL_383194 <- ggplot(readlengths$readlength_383194, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 383194")) + 
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

RL_383202 <- ggplot(readlengths$readlength_383202, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 383202")) + 
  theme_minimal() + 
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)  
  )

RL_383205 <- ggplot(readlengths$readlength_383205, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 383205")) + 
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

RL_507264 <- ggplot(readlengths$readlength_507264, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 507264")) + 
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

RL_507265 <- ggplot(readlengths$readlength_507265, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 507265")) + 
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

RL_759877 <- ggplot(readlengths$readlength_759877, aes(x = V1)) +
  geom_histogram(binwidth = 10, fill = "black") +
  xlab("Read Lengths (bp)") +
  ggtitle(paste("Sample 759877")) + 
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_rect(color = "black", fill = NA) 
  )

# ARRANGE AND SAVE
RL <- ggarrange(
        RL_29779,
        RL_383194, 
        RL_383202, 
        RL_383205, 
        RL_507264, 
        RL_507265, 
        RL_759877, 
        nrow=4,
        ncol=3)

ggsave("/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/hKIWA_reads.png", RL, width = 12, height = 8)
```

## Run R Script Via Command Line
```bash
chmod +x plot_readlengths_h.R
./plot_readlengths_h.R
```

## Run R Script as Job
```bash
nano $scripts_folder/plot_readlengths_h.bash
#!/bin/bash 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --mem=50GB 
#SBATCH --time=3:00:00 
#SBATCH --account=open 

#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
cd $scripts_folder/plots

#Load R
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

#Run R script
R --file=$scripts_folder/plots/plot_readlengths_h.R
```

## Download
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/hKIWA_reads.png /Users/abc6435/Desktop/KROH/figures