# Plot GONE 

## Download Data
```bash
#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
#Rename Files in cluster and remove first line
for i in $(seq 2 5); do
  mv $gone_folder/gone_${i}M/Output_Ne_gone $gone_folder/gone_${i}M/Output_Ne_gone_${i}M
  sed -i '1d' $gone_folder/gone_${i}M/Output_Ne_gone_${i}M;
done

for i in $(seq 1 10); do
  sed -i '1d' $gone_folder/gone_${i}00K/Output_Ne_gone_rep${i};
done

#Set Variables
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
#Download Files to local
for i in $(seq 2 5); do
  rsync abc6435@submit.hpc.psu.edu:$gone_folder/gone_${i}M/Output_Ne_gone_${i}M /Users/abc6435/Desktop/KROH/data/gone;
done

for i in $(seq 1 10); do
  rsync abc6435@submit.hpc.psu.edu:$gone_folder/gone_${i}00K/Output_Ne_gone_rep${i} /Users/abc6435/Desktop/KROH/data/gone;
done

## Setup
```r
library(ggplot2)
library(reshape2)
```

## Import and Modify Data
```r
{r import_data}
Generation <- seq(1:18)
Geometric_mean_2M <- c(202.573,202.573,202.573,202.573,297.341,307.873,308.56,309.513,302.865,306.968,317.013,318.916,327.053,331.921,335.921,418.847,780.787,1880.18)
Geometric_mean_4M <- Geometric_mean_2M + 7

d <- as.data.frame(cbind(Generation,Geometric_mean_2M, Geometric_mean_4M))
d_melt <- melt(d, value.name="Ne", id="Generation")
```
## Plot Data
```r
ggplot(data = d_melt, aes(x=Generation, y=Ne, color = variable)) + 
  geom_line()