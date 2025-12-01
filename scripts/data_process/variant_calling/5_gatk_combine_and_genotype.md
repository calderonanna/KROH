## Combine and Genotype
```bash
nano $scripts/combine_genotype_gvcfs.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --ntasks=4
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=combine_genotype_gvcfs
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
samples=$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf/*.g.vcf | sed 's/^/--variant /')

#Combine GVCFs
gatk CombineGVCFs \
    $samples \
    -O $gatk/gvcf/dSETO_comb.vcf \
    -R $ref \
    >& $gatk/log/dSETO_comb.log

#Zip and Index
for i in `cat $scripts/SETO_IDS_e759877.txt`; do 
    nohup bgzip $gatk/gvcf/${i}*.g.vcf; 
done

nohup bgzip $gatk/gvcf/dSETO_comb.vcf
nohup tabix $gatk/gvcf/dSETO_comb.vcf.gz

#Genotype
gatk --java-options "-Xmx100g" GenotypeGVCFs \
    -R $ref \
    -V $gatk/gvcf/dSETO_comb.vcf.gz -O $gatk/vcf/dSETO.vcf.gz
```

