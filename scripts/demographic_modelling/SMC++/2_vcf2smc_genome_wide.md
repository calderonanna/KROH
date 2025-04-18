# Convert VCF to SMC Format
vcf2smc can only be run on a single contig or chromosome.

## Filter VCF
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/filter_vcf_smc++.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=08:00:00
#SBATCH --account=open
#SBATCH --job-name=filter_vcf_smc++
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"

#Samples: Exclude hKIWA
bcftools view \
    -S $scripts_folder/HOWA_AMRE_cKIWA_IDS.txt \
    $vcf_folder/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz \
    -Oz -o $work_dir/HOWA_AMRE_cKIWA_tags_auto_bi.vcf.gz

#Genotype: Read Depth and Genotype Quality
bcftools filter \
    -e 'FORMAT/DP < 10 || FORMAT/GQ < 20' \
    --set-GTs . \
    $work_dir/HOWA_AMRE_cKIWA_tags_auto_bi.vcf.gz \
    -Oz -o $work_dir/HOWA_AMRE_cKIWA_tags_auto_bi_gtdp_gtgq.vcf.gz

#Genotype: Missing
bcftools view -e \
    'N_MISSING>3' \
    $work_dir/HOWA_AMRE_cKIWA_tags_auto_bi_gtdp_gtgq.vcf.gz\
    -Oz -o $work_dir/HOWA_AMRE_cKIWA_smc++.vcf.gz
```

## VCF2SMC
```bash
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/vcf2smc.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=9:00:00
#SBATCH --account=open
#SBATCH --job-name=vcf2smc
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables 
bin="/storage/home/abc6435/SzpiechLab/bin"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"
vcf="HOWA_AMRE_cKIWA_tags_auto_bi_gtdp_gtgq.vcf.gz"

#Index VCF
cd $work_dir
tabix $work_dir/$vcf

#Run vcf2smc
for i in `cat $scripts/autochrs.txt`; do
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
        smc++ vcf2smc \
        $work_dir/$vcf \
        $work_dir/${i}_cKIWA.smc.gz \
        ${i} \
        cKIWA:183195332,183194861,183195321,183195304,183194841,183195326,183195312; 
    done
```

