
## ROH Summary
```bash
#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/roh/garlic"
shared="/storage/home/abc6435/SzpiechLab/shared"


#Remove any ROH < 0.5MB
cat $work_dir/KIWA.roh.bed  | awk -F '\t' '$5>500000 || /track/ {print$0}' > $work_dir/KIWA_0.5MB.roh.bed

#Create ID File
sed 's/ /\t/g' $work_dir/KIWA.tfam | cut -f1,2 >> $work_dir/ids.txt
awk '{print $2, $1}' $work_dir/ids.txt > $work_dir/temp && mv -f $work_dir/temp $work_dir/ids.txt

#Calculate ROH Fractions
$shared/calculate_ROH_fractions.pl $work_dir/KIWA_0.5MB.roh.bed 6 $work_dir/ids.txt > $work_dir/KIWA_roh_sum_0.5MB.txt
```