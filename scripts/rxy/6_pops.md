# Input-Pop

```bash
#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#ID Files 
awk '{print $1, $2="A"}' OFS="\t" $scripts/hKIWA_e759877_IDS.txt > $work_dir/pop_A.txt
awk '{print $1, $2="B"}' OFS="\t" $scripts/cKIWA_IDS.txt > $work_dir/pop_B.txt
```