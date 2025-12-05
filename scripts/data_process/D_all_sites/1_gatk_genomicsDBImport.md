# gatk GenomicsDBImport 
https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html

## Unzip and Index (.idx) gvcfs
```bash
nano $scripts/unzip.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=6:00:00
#SBATCH --account=open
#SBATCH --job-name=unzip
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
gvcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf"

for i in $(cat $scripts/KIWA_IDS_e759877.txt); do
    gunzip $gvcf/${i}*rescaled.g.vcf.gz
done
```

## gatk GenomicsDBImport
```bash
for i in $(cat $scripts/autochrs.txt); do
    cat<<EOT > $scripts/gatk_allsites_${i}.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --account=dut374_hc_default
#SBATCH --job-name=gatk_allsites_${i}
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
ref="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/mywa_reference/mywagenomev2.1.fa"
allsites="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/allsites"
samples=\$(realpath /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk/gvcf/*rescaled.g.vcf | sed 's/^/--variant /')

#GenomicsDBImport
gatk --java-options "-Xmx10g" GenomicsDBImport \\
    \$samples \\
    --genomicsdb-workspace-path \$allsites/${i} \\
     -L ${i}
EOT
done

#Submit Scripts
for i in $(cat $scripts/autochrs.txt); do
    sbatch $scripts/gatk_allsites_${i}.bash
done
```