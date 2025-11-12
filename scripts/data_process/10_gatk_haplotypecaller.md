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
    -O \$gatk/gvcf/${i}.g.vcf \\
    --native-pair-hmm-threads 2 \\
    >& \$gatk/log/${i}gvcf.log
EOT
done

# Check For Completion
cd $gatk/gcvf
for file in $(ls); do 
    echo $file
    grep "Caller done" $file
    echo ""; 
done
```