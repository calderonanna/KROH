# All Sites
https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html

## gatk GenomicsDBImport & gatk GenotypeGVCFs
```bash
#Index gvcfs
for f in $gvcf/*.g.vcf.gz; do
    gatk IndexFeatureFile -I $f
done

#Create Scripts
for i in $(cat $scripts/autochrs.txt); do
    cat<<EOT > $scripts/gatk_allsites_${i}
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=gatk_allsites_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
samples=\$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf/*.g.vcf.gz | sed 's/^/--variant /')

#GenomicsDBImport
/usr/bin/time -v gatk --java-options "-Xmx10g" GenomicsDBImport \\
    \$samples \\
    --genomicsdb-workspace-path \$allsites/${i} \\
     -L ${i}

#GenotypeGVCFs
gatk --java-options "-Xmx10g" GenotypeGVCFs \\
    -R \$ref \\
    -V gendb://\$allsites/${i} \\
    -all-sites \\
    -O \$allsites/${i}.vcf.gz
EOT
done
```

## gatk MergeVCFs
```bash
nano $scripts/gatk_merge.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=gatk_merge
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
vcfs=$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites/*.vcf.gz | sed 's/^/-I /')

#MergeVcfs
gatk MergeVcfs \
    $vcfs \
    -O $allsites/KIWA_allsites.vcf.gz
```

