# Pixy
https://pixy.readthedocs.io/en/latest/arguments.html
```bash
#Load Python 3.11.2
module load python/3.11.2
module use python/3.11.2
python3 --version

#Activate pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

#Set Variables
scripts="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
pixy="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/pixy"
gatk="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gatk"

#Create Population File
# cat $scripts/hKIWA_IDS_e759877.txt | awk '{print $0, $1="hKIWA"}' OFS='\t' >> $pixy/pops.txt
# cat $scripts/cKIWA_IDS.txt | awk '{print $0, $1="cKIWA"}' OFS='\t' >> $pixy/pops.txt

#Index VCF
cd $allsites
nohup tabix $allsites/KIWA_allsites.vcf.gz

#Run Pixy 
pixy --stats pi fst \
--vcf $allsites/KIWA_allsites.vcf.gz \
--populations $pixy/pops.txt
--n_cores 4 \
--output_folder $pixy
--output_prefix pixy_out
