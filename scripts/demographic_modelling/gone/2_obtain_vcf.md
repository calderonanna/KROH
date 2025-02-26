# Obtain VCF File
Because I'm using the HOSP linkage map, I am alignming my raw sequences to the HOSP reference and calling variants. 

## Alignments
```bash
#Set Variables
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
ref_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hofi_ref"

#Index Ref
gunzip $ref_folder/hofigenome.fna.gz
bwa index -p hofigenome -a bwtsw $ref_folder/hofigenome.fna

#Create scripts
for i in `cat $scripts_folder/cKIWA_IDS.txt`; do 
    cat <<EOT > $scripts_folder/hofi_alignments_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20GB
#SBATCH --time=12:00:00
#SBATCH --account=open
#SBATCH --job-name=hofi_alignments_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
data_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
err_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
hofi_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hofi_ref"
picard_tools_folder="/storage/home/abc6435/ToewsLab/bin/picard_tools_2.20.8"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt/kirtlandii"

#Run BWA 
#bwa mem -R "@RG\tID:${i}\tSM:${i}" -M -t 4 \\
#\$hofi_folder/hofigenome \\
#\$data_folder/trim/${i}_R1_trimmed.fastq.gz \\
#\$data_folder/trim/${i}_R2_trimmed.fastq.gz > \\
#\$work_dir/${i}.sam 2> \\
#\$err_folder/${i}_bwa_hofi.err

#Convert sam to bam
#samtools view -S -b \$work_dir/${i}.sam > \$work_dir/${i}.bam

#sort
#samtools sort \$work_dir/${i}.bam -T \$work_dir/${i}_temp.bam -o \$work_dir/${i}_sorted.bam

#Mark Duplicates
java -Xmx20g -jar \$picard_tools_folder/picard.jar MarkDuplicates INPUT=\$work_dir/${i}_sorted.bam OUTPUT=\$work_dir/${i}_marked.bam METRICS_FILE=\$work_dir/${i}_metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000

#Index BAM Files
samtools index \$work_dir/${i}_marked.bam \$work_dir/${i}_marked.bai
EOT
done

#Submit Each Script
for i in $scripts_folder/hofi_alignments_*.bash; do
    sbatch ${i}
done
```
## Call Variants
```bash
nano $scripts_folder/call_variants_gone.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10GB
#SBATCH --time=11:00:00
#SBATCH --account=open
#SBATCH --job-name=call_variants_gone
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out
#SBATCH --output=/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output/%x.%j.out

#Set Variables
hofi_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/hofi_ref"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt/kirtlandii"

#Call Variants
samtools mpileup -f \$hofi_folder/hofigenome.fna \$work_dir/*_marked.bam  | bcftools call -mv -Oz -o \$work_dir/kirtlandii.vcf.gz

#Filter Variants
bcftools view -m2 -M2 -v snps \$vcf.vcf.gz -Oz -o \$vcf.biallelic.vcf.gz

bcftools view -i 'QUAL>=50' \$vcf.biallelic.vcf.gz -Oz -o \$vcf.biallelic.qual.vcf.gz

bcftools view -e 'SUM(FMT/DP)<95 | SUM(FMT/DP)>185' \$vcf.biallelic.qual.vcf.gz -Oz -o \$vcf.biallelic.qual.dpsites.vcf.gz

bcftools filter \$vcf.biallelic.qual.dpsites.vcf.gz -e 'FMT/DP<6' -S . -Oz -o \$vcf.biallelic.qual.dpsites.dpgt.vcf.gz

bcftools filter \$vcf.biallelic.qual.dpsites.dpgt.vcf.gz -e 'FMT/GQ<20' -S . -Oz -o \$vcf.biallelic.qual.dpsites.dpgt.gq.vcf.gz

bcftools view -e 'GT="./."' \$vcf.biallelic.qual.dpsites.dpgt.gq.vcf.gz -Oz -o \$vcf.biallelic.qual.dpsites.dpgt.gq.nmiss.vcf.gz

bcftools view -e 'COUNT(GT="het")>=6' \$vcf.biallelic.qual.dpsites.dpgt.gq.nmiss.vcf.gz -Oz -o \$vcf.biallelic.qual.dpsites.dpgt.gq.nmiss.exhet.vcf.gz

bcftools index \$vcf.biallelic.qual.dpsites.dpgt.gq.nmiss.exhet.vcf.gz
```

## Clean VCF 
```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
nano $scripts_folder/gone_vcf_kirt.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4GB
#SBATCH --time=5:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=basic

#Set Variables
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt/kirtlandii.biallelic.qual.dpsites.dpgt.gq.nmiss.exhet.vcf.gz"
vcf_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/vcf_kirt"
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"

#Make a list of chromosome names
bcftools query -f '%CHROM\n' "$vcf" | uniq > $vcf_folder/rename_chr.txt
awk '{print $1,$2="chr"NR}' OFS="\t" $vcf_folder/rename_chr.txt > $vcf_folder/temp && mv -f $vcf_folder/temp $vcf_folder/rename_chr.txt
cat $vcf_folder/rename_chr.txt | awk '!($1 ~ /scaffold/)' | awk '!($1 ~ /chrz/)'| awk '!($1 ~ /mito/)' > $vcf_folder/temp && mv -f $vcf_folder/temp $vcf_folder/rename_chr.txt

#Extract autosomes
chr_list=($(cut -f1 $vcf_folder/rename_chr.txt))
chr_string=$(IFS=,; echo "${chr_list[*]}")

bcftools view $vcf -r $chr_string -Oz -o $vcf_folder/auto.vcf.gz
bcftools index $vcf_folder/auto.vcf.gz
```
