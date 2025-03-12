# Obtain VCF File
## Alignments
HOSP REF: PRJNA255814
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
ref_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hosp_ref"

#Index Ref
gunzip $ref_folder/hospgenome.fna.gz
bwa index -p hospgenome -a bwtsw $ref_folder/hospgenome.fna

for i in `cat $scripts_folder/cKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/hosp_alignments_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=hosp_alignments_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
hosp_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hosp_ref"
picard_tools_folder="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"

#Run BWA 
bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 4 \\
\$hosp_folder/hospgenome \\
\$data_folder/trim/${i}_R1_trimmed.fastq.gz \\
\$data_folder/trim/${i}_R2_trimmed.fastq.gz > \\
\$work_dir/${i}.sam 2> \\
\$err_folder/${i}_bwa_hosp.err

#Convert sam to bam
samtools view -S -b \$work_dir/${i}.sam > \$work_dir/${i}.bam

#sort
samtools sort \$work_dir/${i}.bam -T \$work_dir/${i}_temp.bam -o \$work_dir/${i}_sorted.bam

#Mark Duplicates
java -Xmx100g -jar \$picard_tools_folder/picard.jar MarkDuplicates INPUT=\$work_dir/${i}_sorted.bam OUTPUT=\$work_dir/${i}_marked.bam METRICS_FILE=\$work_dir/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index BAM Files
samtools index \$work_dir/${i}_marked.bam \$work_dir/${i}_marked.bai
EOT
done

#Submit Each Script
for i in $scripts_folder/hosp_alignments_*.bash; do
    sbatch ${i}
done
```

## Call Variants
```bash
nano $scripts_folder/call_variants_gone.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --time=48:00:00
#SBATCH --account=zps5164_sc
#SBATCH --job-name=call_variants_gone
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hosp_ref/hospgenome.fna"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"

#Call Variants
bcftools mpileup -f $ref -b $work_dir/bam_list.txt | bcftools call -mv --ploidy 2 -Oz -o $work_dir/KIWA_gone.vcf.gz
```

## Filter
```bash
salloc --nodes 1 --ntasks 1 --mem=10G --time=6:00:00 

work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"

bcftools view -m2 -M2 -v snps $work_dir/KIWA_gone.vcf.gz -Oz -o $work_dir/KIWA_gone_bi.vcf.gz
bcftools filter -e 'QUAL<50 || INFO/DP<24 || INFO/DP>149' $work_dir/KIWA_gone_bi.vcf.gz -Oz -o $work_dir/KIWA_gone_bi_qual_dp.vcf.gz
bcftools view -e 'GT="./."' $work_dir/KIWA_gone_bi_qual_dp.vcf.gz -Oz -o $work_dir/KIWA_gone_bi_qual_dp_nmiss.vcf.gz
bcftools view -e 'COUNT(GT="het")>=6' $work_dir/KIWA_gone_bi_qual_dp_nmiss.vcf.gz -Oz -o $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet.vcf.gz
bcftools view -c 1:minor $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet.vcf.gz -Oz -o $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet_poly.vcf.gz
bcftools index $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet_poly.vcf.gz
```

## Split VCF by CHR
![alt text](../../../diagrams/hosp_chr_names.png)
```bash
salloc --nodes 1 --ntasks 1 --mem=100G --time=8:00:00 
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"

#Rename chromosomes as in hagen map file 
bcftools annotate --rename-chrs chrs_hagen.txt -Oz -o KIWA_gone_bi_qual_dp_nmiss_exhet_poly_renamed.vcf.gz KIWA_gone_bi_qual_dp_nmiss_exhet_poly.vcf.gz 

bcftools index $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet_poly_renamed.vcf.gz

#Split VCF by CHR
chr_list=($(cut -f2 $work_dir/chrs_hagen.txt))
for i in "${chr_list[@]}"; do
    bcftools view $work_dir/KIWA_gone_bi_qual_dp_nmiss_exhet_poly_renamed.vcf.gz -r ${i} -Oz -o $work_dir/${i}.vcf.gz
done
```