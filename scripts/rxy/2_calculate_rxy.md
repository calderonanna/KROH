# Calculate Rxy

## Download Rxy-kin
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

#Git Clone
cd $bin
git clone https://github.com/szpiech/Rxy-kin.git

#Add it to PATH
echo 'export PATH=$PATH:/storage/home/abc6435/SzpiechLab/bin/Rxy-kin/Rxy-kin.py' >> ~/.bashrc
source ~/.bashrc
```

## Run Rxy 
`Rxy-kin.py -v VCF_FILE -1 SITE1_FILE -2 SITE2_FILE -A POP_A_FILE -B POP_B_FILE [-l] [-f PERCENTAGE] [-n ITERATIONS]`

```bash
#Set Variables
vcf="KIWA_tags_e759877_bi_qual_dp_nmiss_exhet_auto_maf.vcf.gz"
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
data="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data"
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

#Obtain ID File 
awk '{print $1, $2="A"}' OFS="\t" $scripts/cKIWA_IDS.txt > $data/pop_A.txt
awk '{print $1, $2="B"}' OFS="\t" $scripts/hKIWA_IDS.txt > $data/pop_B.txt

#Filter VCF File
bcftools view -i 'N_MISSING<1' $data/vcf/$vcf -Oz -o $data/rxy/nomissing.vcf.gz 
bcftools annotate -x INFO,FORMAT $data/rxy/nomissing.vcf.gz -Oz -o $data/rxy/nomissing_gt.vcf.gz

#Obtain Intergenic Sites (vcf_sites-annotated_sites)
#make a bed file of all annotated sites. Then extract those sites from vcf. From that bed file, randomly sample 2 sets of 10K sites. 

$rxy/Rxy-kin.py -v $data/rxy/nomissing_gt.vcf.gz -1 $data/rxy/deleterious.txt -2 $data/rxy/noncoding.txt -A $data/rxy/pop_A.txt -B $data/rxy/pop_B.txt