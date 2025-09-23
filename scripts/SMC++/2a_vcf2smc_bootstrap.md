# vcf2SMC Bootstrapping 
To simulate the bootstrapping feature from older smc++ version, I first split my vcf into 1M Non-overlapping Windows. Then, I sampled windows (with replacement) until the total length of the genome is roughly equal to the original genome length (autsomal size is 938,591,657 bases)

## Split VCF 
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/split_vcf_smc++.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=05:00:00
#SBATCH --account=open
#SBATCH --job-name=split_vcf_smc++
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Define Windows 
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/HOWA_AMRE_cKIWA_smc++.vcf.gz"

bcftools view -h \
    $vcf | \
    grep =chr \
    > $work_dir/chrlengths.txt

sed -i 's/##contig=<ID=//g' $work_dir/chrlengths.txt
sed -i 's/,length=/ /g' $work_dir/chrlengths.txt
sed -i 's/>//g' $work_dir/chrlengths.txt
sed -i '$d' $work_dir/chrlengths.txt
sed -i 's/ /\t/g' $work_dir/chrlengths.txt

bedtools makewindows -g \
    $work_dir/chrlengths.txt \
    -w 1000000 \
    > $work_dir/windows.bed

#Extract Windows
bed="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap/windows.bed"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"

while read chrom start end; do
    bcftools view -r \
        ${chrom}:${start}-${end} $vcf \
        -Oz -o ${work_dir}/${chrom}_${start}_${end}.vcf.gz
done < $bed
```

## Create Bootstraps
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/bootstrap_vcf_smc++.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=30GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=bootstrap_vcf_smc++
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
n_win=938
n_rep=100

for rep in $(seq 1 $n_rep); do
    find $work_dir/*gz -type f | shuf -n $n_win > $work_dir/vcf_list_${rep}.txt
    for chr in `cat $scripts/autochrs.txt`; do
        grep "/${chr}_" $work_dir/vcf_list_${rep}.txt \
        >> $work_dir/temp_${rep};
    done
    mv -f $work_dir/temp_${rep} $work_dir/vcf_list_${rep}.txt
    bcftools concat -f \
        $work_dir/vcf_list_${rep}.txt -Ou | \
        bcftools sort \
        -Oz -o $work_dir/bootstrap_${rep}.vcf.gz
    tabix $work_dir/bootstrap_${rep}.vcf.gz
    rm -rf $work_dir/vcf_list_${rep}.txt;
done
```

## Run VCF2SMC
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/vcf2smc_bootstrap_1.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=2:00:00
#SBATCH --account=open
#SBATCH --job-name=vcf2smc_bootstrap_1
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"
vcf="bootstrap_1.vcf.gz"

bcftools query -f \
    '%CHROM' \
    $vcf | \
    uniq \
    >> $work_dir/bootstrap_1_autochrs.txt

#Run vcf2smc
for i in `cat $work_dir/bootstrap_1_autochrs.txt`; do
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
        smc++ vcf2smc \
        $work_dir/$vcf \
        $work_dir/bootstrap_1_${i}.smc.gz \
        ${i} \
        cKIWA:183195332,183194861,183195321,183195304,183194841,183195326,183195312; 
    done

rm -rf $work_dir/bootstrap_1_autochrs.txt
rm -rf $work_dir/bootstrap_1.vcf.gz 
rm -rf $work_dir/bootstrap_1.vcf.gz.tbi

#Submit scripts
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++/bootstrap"
n_rep=100

for rep in $(seq 2 $n_rep); do
    #cp $scripts_folder/vcf2smc_bootstrap_1.bash $scripts_folder/vcf2smc_bootstrap_${rep}.bash
    #sed -i "s/bootstrap_1/bootstrap_${rep}/g" $scripts_folder/vcf2smc_bootstrap_${rep}.bash
    sbatch $scripts_folder/vcf2smc_bootstrap_${rep}.bash;
done