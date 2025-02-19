# Plot GONE 

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