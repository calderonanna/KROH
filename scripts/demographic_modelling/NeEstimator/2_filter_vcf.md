# Filter VCF

```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/filter_vcf_rldne.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=08:00:00
#SBATCH --account=open
#SBATCH --job-name=filter_vcf_rldne
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/vcf"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

#Genotype: Read Depth and Genotype Quality
bcftools filter \
    -e 'FORMAT/DP < 6 || FORMAT/GQ < 20' \
    --set-GTs . \
    $vcf_folder/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz \
    -Oz -o $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_gtdp_gtgq.vcf.gz

#Genotype: Missing 
bcftools view -i \
    'N_MISSING=0' \
    $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_gtdp_gtgq.vcf.gz \
    -Oz -o $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_gtdp_gtgq_nmiss.vcf.gz

#Remove Monomorphic Sites
bcftools view -e \
    'COUNT(GT="AA")=N_SAMPLES || COUNT(GT="RR")=N_SAMPLES' \
    $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_gtdp_gtgq_nmiss.vcf.gz \
    -Oz -o $work_dir/chKIWA_AMRE_HOWA_tags_auto_bi_gtdp_gtgq_nmiss_poly.vcf.gz

```

