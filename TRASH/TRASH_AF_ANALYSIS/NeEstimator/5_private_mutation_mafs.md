# Private Mutation MAFS
```bash
nano $scripts/mutations_mafs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --time=100:00:00
#SBATCH --account=dut374_hc_default
#SBATCH --job-name=mutations_mafs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
basedir='/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy'
scripts='/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts'
mutations="deleterious tolerated lossoffunction noncoding nonsynonymous synonymous"

# # #Create Keys
# for i in `cat $scripts/autochrs.txt`; do
#     zgrep -E "^${i}\b" $basedir/cKIWA.mafs.gz | awk '{print $0, $1"_"$2}' OFS="\t" >> $basedir/cKIWA_${i}_mafs.keyvalue;
# done

# for i in `cat $scripts/autochrs.txt`; do
#     zgrep -E "^${i}\b" $basedir/hKIWA.mafs.gz | awk '{print $0, $1"_"$2}' OFS="\t" >> $basedir/hKIWA_${i}_mafs.keyvalue;
# done

# for i in $(echo $mutations); do
#     awk '{print $1"_"$3}' OFS="\t" $basedir/private_mutations/chKIWA_${i}.bed >> $basedir/private_mutations/chKIWA_${i}.key;
# done

#Merge  
#file1: {array[key_file1]=value_file1;next}
#file2: $key_file2 in array {print array[key_file2]}
#array[key_file2=value_file1 (matches keys in file2 to values in file1)

for i in `cat $scripts/autochrs.txt`; do
    for j in $(echo $mutations); do
        awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/cKIWA_${i}_mafs.keyvalue $basedir/private_mutations/chKIWA_${j}.key >> $basedir/cKIWA_${j}_temp.maf;
    done;
done

for i in `cat $scripts/autochrs.txt`; do
    for j in $(echo $mutations); do
        awk 'NR==FNR{a[$8]=$0; next} $1 in a {print a[$1]}' $basedir/hKIWA_${i}_mafs.keyvalue $basedir/private_mutations/chKIWA_${j}.key >> $basedir/hKIWA_${j}_temp.maf;
    done;
done

#Modify Files
for i in $(echo $mutations); do
    cut -f 1-7 $basedir/hKIWA_${i}_temp.maf >> $basedir/hKIWA_${i}.maf
    cut -f 1-7 $basedir/cKIWA_${i}_temp.maf >> $basedir/cKIWA_${i}.maf;
done

mv $basedir/*.keyvalue $basedir/keyvalues
```