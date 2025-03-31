# Sample Sites 
GONE does not need all sites in a vcf to run. In the GitHub issues, Armando recommends to have NO MORE than 100K sites per chromosome. Kardos et al. 2020 used 10,000 SNPS/chr and repeated 500 times to create confidence intervals. 


## Sample Sites
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/gone_sample_sites_R0.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=1:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic
#SBATCH --job-name=gone_sample_sites_R0
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
chr_list=($(cut -f2 $work_dir/chrs_hagen.txt))

#Obtain Header
bcftools view -h $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet_poly_renamed.vcf.gz > $work_dir/R0.vcf

#Sample sites
for i in "${chr_list[@]}"; do
    bcftools view -H $work_dir/${i}.vcf.gz | shuf -n 5000 | sort -g --key=2,3 >> $work_dir/R0.vcf;
done
 
 ```

## Replicate Script
```bash
for i in $(seq 101 300); do
    rm -rf $scripts_folder/gone_sample_sites_R${i}.bash
    cp $scripts_folder/gone_sample_sites_R0.bash $scripts_folder/gone_sample_sites_R${i}.bash
    sed -i "s/R0/R${i}/g" $scripts_folder/gone_sample_sites_R${i}.bash
    sbatch $scripts_folder/gone_sample_sites_R${i}.bash;
done
