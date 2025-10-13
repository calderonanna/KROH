# GATK4

## Installation
```bash
#Install sdk
curl -s "https://get.sdkman.io" | bash
echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc

#Choose Java Version 17
cd /storage/home/abc6435/.sdkman/candidates/java
sdk list java
sdk install java 17.0.16-tem

echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.16-tem"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#Install GATK4 and add to bashrc
cd /storage/home/abc6435/SzpiechLab/bin
wget https://github.com/broadinstitute/gatk/releases/download/4.6.2.0/gatk-4.6.2.0.zip
unzip gatk-4.6.2.0.zip
rm -rf gatk-4.6.2.0.zip
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/gatk-4.6.2.0:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## HaplotypeCaller
```bash
for i in `cat $scripts/KIWA_IDS_e759877.txt`;do
    cat<<EOT > $scripts/haplotypecaller_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=50GB
#SBATCH --ntasks=2
#SBATCH --time=100:00:00
#SBATCH --account=zps5164_cr_default
#SBATCH --partition=himem
#SBATCH --job-name=haplotypecaller_${i}.bash
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Index bams
cd \$bam
samtools index \$bam/${i}_sorted_marked.rescaled.bam

#Run HaplotypeCaller
gatk HaplotypeCaller \\
    -R \$ref \\
    -I \$bam/${i}_sorted_marked.rescaled.bam\\
    -ERC GVCF \\
    -O \$gatk/${i}.g.vcf \\
    --native-pair-hmm-threads 2 \\
    >& \$gatk/log/${i}gvcf.log
EOT
done
```

## Combine and Genotype
```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=150GB
#SBATCH --ntasks=4
#SBATCH --time=100:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=derive
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"
bam="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/bam"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Combine GVCFs
samples=$(ls $gatk/*.g.vcf | sed 's/^/--variant /')
gatk CombineGVCFs \
    $(echo $samples) \
    -O $gatk/KIWA_comb.vcf \
    -R $ref \
    >& $gatk/log/KIWA_gvcfs.log

#Zip and Index
for i in `cat $scripts/KIWA_IDS_e759877.txt`; do 
    nohup bgzip $gatk/${i}.g.vcf; 
done
nohup bgzip $gatk/KIWA_comb.vcf
nohup tabix $gatk/KIWA_comb.vcf.gz

#Genotype
gatk --java-options "-Xmx100g" GenotypeGVCFs \
    -R $ref \
    -V $gatk/KIWA_comb.vcf.gz -O $gatk/KIWA.vcf.gz
```
