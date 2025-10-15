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
cat $scripts/hKIWA_IDS_e759877.txt | awk '{print $0, $1="hKIWA"}' OFS='\t' >> $pixy/pops.txt
cat $scripts/cKIWA_IDS.txt | awk '{print $0, $1="cKIWA"}' OFS='\t' >> $pixy/pops.txt

#Run Pixy 
pixy --stats pi\
    --vcf $gatk/KIWA_bi_qual_gtdp_gtgq_fmiss_exhet.vcf.gz
