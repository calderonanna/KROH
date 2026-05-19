# gatk GenotypeGVCFs
https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html

```bash
for i in $(cat $scripts/autochrs.txt); do
    cat<<EOT > $scripts/gatk_allsites_genotypevcfs_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=gatk_allsites_genotypevcfs_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"

#GenotypeGVCFs
gatk --java-options "-Xmx10g" GenotypeGVCFs \\
    -R \$ref \\
    -V gendb://\$allsites/${i} \\
    -all-sites \\
    -O \$allsites/${i}.vcf.gz
EOT
done

#Submit Scripts
for i in $(cat $scripts/autochrs.txt); do
    sbatch $scripts/gatk_allsites_genotypevcfs_${i}.bash
done
```