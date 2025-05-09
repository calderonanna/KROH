# Plot Depth Distributions
https://3billion.io/blog/sequencing-depth-vs-coverage


## Load R Module and Install Packages
```bash
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('ggplot2', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('tidyverse', lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('ggpubr', dependencies=TRUE, lib='/storage/group/zps5164/default/bin/.R')"

Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('dplyr', dependencies=TRUE, lib='/storage/group/zps5164/default/bin/.R')"

```
## Create R Script
```R
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/plots/plot_depth_h.R

#!/usr/bin/env Rscript

# CALL PACKAGES
library(ggpubr, lib.loc='/storage/group/zps5164/default/bin/.R')
library(ggplot2, lib.loc='/storage/group/zps5164/default/bin/.R')
library(tidyverse, lib.loc='/storage/group/zps5164/default/bin/.R')
library(dplyr, lib.loc='/storage/group/zps5164/default/bin/.R')

# SET VARIABLES AND IMPORT DATA
setwd("/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seq_stats")

ids <- c(29779, 383194, 383202,
         383205,507264, 507265, 759877)

for(id in ids){
  command <- paste('depth_',id, ' <- read.table("',id, '_depth.txt", header = FALSE, sep="\t", col.names = c("CHR", "POS", "DEPTH"))', sep="")
  eval(parse(text=command))
}

# CALCULATE AVERAGE DEPTH
for(id in ids){
  command2 <- paste('avg_depth_',id, ' <- aggregate(DEPTH ~ CHR, data=depth_',id, ',FUN=mean)', sep="")
  eval(parse(text=command2))
}

# PLOT AND SAVE
chr_order <- c("chr1","chr1a","chr2","chr3","chr4","chr4a","chr5","chr6","chr7",
"chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr17","chr18",
"chr19","chr20","chr21","chr22","chr23","chr24","chr25","chr26","chr27","chr28","chr29")

avg_depth_29779$CHR <- factor(avg_depth_29779$CHR, levels = chr_order)
DP_29779 <-  ggplot(avg_depth_29779, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 29779")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_383194$CHR <- factor(avg_depth_383194$CHR, levels = chr_order)
DP_383194 <-  ggplot(avg_depth_383194, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 383194")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_383202$CHR <- factor(avg_depth_383202$CHR, levels = chr_order)
DP_383202 <-  ggplot(avg_depth_383202, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 383202")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_383205$CHR <- factor(avg_depth_383205$CHR, levels = chr_order)
DP_383205 <-  ggplot(avg_depth_383205, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 383205")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_507264$CHR <- factor(avg_depth_507264$CHR, levels = chr_order)
DP_507264 <-  ggplot(avg_depth_507264, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 507264")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_507265$CHR <- factor(avg_depth_507265$CHR, levels = chr_order)
DP_507265 <-  ggplot(avg_depth_507265, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 507265")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_759877$CHR <- factor(avg_depth_759877$CHR, levels = chr_order)
DP_759877 <-  ggplot(avg_depth_759877, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "black") +
  scale_y_continuous(limits = c(0,30)) +
  labs(x = "",
       y = "Average Depth") +
 ggtitle(paste("Sample 759877")) + 
 theme_minimal() +
  theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

# ARRANGE AND SAVE
DP <- ggarrange(
        DP_29779,
        DP_383194, 
        DP_383202, 
        DP_383205, 
        DP_507264, 
        DP_507265, 
        DP_759877, 
        nrow=4,
        ncol=3)

ggsave("/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/hKIWA_depth.png", DP, width = 15, height = 8, dpi=300)
```

## Run R Script as Job
```bash
nano $scripts_folder/plot_depth_h.bash
#!/bin/bash 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --mem=300GB 
#SBATCH --time=6:00:00 
#SBATCH --account=open 

#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
cd $scripts_folder/plots

#Load R
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

#Run R script
R --file=$scripts_folder/plots/plot_depth_h.R
```

## Download
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/*depth*.png /Users/abc6435/Desktop/KROH/figures
```