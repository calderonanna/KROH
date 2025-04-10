# Convert VCF to SMC Format
vcf2smc can only be run on a single contig or chromosome.

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
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/smc++"
VCF="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf/chKIWA_AMRE_HOWA_tags_auto_bi_qual_dp.vcf.gz"
vcf_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"

cd $work_dir

#Index VCF
#bcftools index $VCF

#Run vcf2smc
for i in `cat $vcf_dir/chrs.txt`; do
    singularity exec --bind $PWD:/mnt $bin/smcpp.sif \
        smc++ vcf2smc \
        $VCF \
        $work_dir/chr${i}_cKIWA.smc.gz \
        chr${i} \
        cKIWA:183195332,183194861,183195321,183195304,183194841,183195326,183195312; 
    done
```