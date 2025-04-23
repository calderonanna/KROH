
## Filter VCF
Final SNP#: 19,961

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

#Samples: Include only hKIWA
# bcftools view \
#     -S $scripts_folder/hKIWA_IDS.txt \
#     $vcf_folder/chKIWA_AMRE_HOWA_tags_auto_bi.vcf.gz \
#     -Oz -o $work_dir/hKIWA_tags_auto_bi.vcf.gz

# #Genotype: Read Depth and Genotype Quality
# bcftools filter \
#     -e 'FORMAT/DP < 6 || FORMAT/GQ < 20' \
#     --set-GTs . \
#     $work_dir/hKIWA_tags_auto_bi.vcf.gz \
#     -Oz -o $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq.vcf.gz

# #Genotype: Missing 
# bcftools view -i \
#     'N_MISSING=0' \
#     $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq.vcf.gz \
#     -Oz -o $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss.vcf.gz

#Remove Monomorphic Sites
bcftools view -e \
    'COUNT(GT="AA")=N_SAMPLES || COUNT(GT="RR")=N_SAMPLES' \
    $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss.vcf.gz \
    -Oz -o $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss_poly.vcf.gz

#Remove Rare Variants
bcftools view -i \
    'MIN(INFO/AF, 1-INFO/AF) > 0.05' \
    $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss_poly.vcf.gz \
    -Oz -o $work_dir/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss_poly_maf.vcf.gz






```

