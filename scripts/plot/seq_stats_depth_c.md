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
nano $scripts_folder/plots/plot_depth_c.R

#!/usr/bin/env Rscript

# CALL PACKAGES
library(ggpubr, lib.loc='/storage/group/zps5164/default/bin/.R')
library(ggplot2, lib.loc='/storage/group/zps5164/default/bin/.R')
library(tidyverse, lib.loc='/storage/group/zps5164/default/bin/.R')
library(dplyr, lib.loc='/storage/group/zps5164/default/bin/.R')

# SET VARIABLES AND IMPORT DATA
setwd("/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/seq_stats")
ids <- c(183194841, 183195312, 183195332,
         183194861,183195321, 183195304, 183195326)

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

avg_depth_183194841$CHR <- factor(avg_depth_183194841$CHR, levels = chr_order)
DP_183194841 <-  ggplot(avg_depth_183194841, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183194841")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183195332$CHR <- factor(avg_depth_183195332$CHR, levels = chr_order)
DP_183195332 <-  ggplot(avg_depth_183195332, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183195332")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183194861$CHR <- factor(avg_depth_183194861$CHR, levels = chr_order)
DP_183194861 <-  ggplot(avg_depth_183194861, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183194861")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183195321$CHR <- factor(avg_depth_183195321$CHR, levels = chr_order)
DP_183195321 <-  ggplot(avg_depth_183195321, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183195321")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183195304$CHR <- factor(avg_depth_183195304$CHR, levels = chr_order)
DP_183195304 <-  ggplot(avg_depth_183195304, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183195304")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183195326$CHR <- factor(avg_depth_183195326$CHR, levels = chr_order)
DP_183195326 <-  ggplot(avg_depth_183195326, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183195326")) + 
 theme_minimal() +
theme(
    axis.text = element_text(size=10),
    axis.text.x = element_text(angle = 90),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA)
  )

avg_depth_183195312$CHR <- factor(avg_depth_183195312$CHR, levels = chr_order)
DP_183195312 <-  ggplot(avg_depth_183195312, aes(x = CHR, y = DEPTH)) +
  geom_bar(stat = "identity", fill = "#73DAFF") +
  labs(x = "",
       y = "Average Depth") +
  ggtitle(paste("Sample 183195312")) + 
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
        DP_183194841,
        DP_183195332, 
        DP_183194861, 
        DP_183195321, 
        DP_183195304, 
        DP_183195326, 
        DP_183195312, 
        nrow=4,
        ncol=3)

ggsave("/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/depth_grid_c.png", DP, width = 15, height = 8, dpi=300)
```

## Run R Script as Job
```bash
nano plot_depth_c.bash
#!/bin/bash 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --mem=300GB 
#SBATCH --time=6:00:00 
#SBATCH --account=zps5164_sc 
#SBATCH --partition=sla-prio 

#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
cd $scripts_folder/plots

#Load R
module use /storage/icds/RISE/sw8/modules/r 
module load r/4.2.1-gcc-8.5.0

#Run R script
R --file=$scripts_folder/plots/plot_depth_c.R
```

## Download
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/plots/depth_grid_c.png /Users/abc6435/Desktop/KROH/figures
```