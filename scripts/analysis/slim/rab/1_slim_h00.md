# h00

```bash
nano $scripts/rxy_simulations_h00.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=20GB
#SBATCH --time=300:00:00
#SBATCH --account=dut374_sc_default
#SBATCH --job-name=rxy_simulations_h00
#SBATCH --error=/storage/home/abc6435/SzpiechLab/abc6435/KROH/err/%x.%j.out

#Set Variables
slim="/storage/group/zps5164/default/bin/SLiM/build/slim"
scripts="/storage/group/zps5164/default/abc6435/KROH/scripts"
h00="/storage/group/zps5164/default/abc6435/KROH/data/slim/rxy/h00"
eggs_folder="/storage/group/zps5164/default/abc6435/KROH/data/slim/eggs/h00"
bin="/storage/group/zps5164/default/bin/Rxy-kin"
results="/storage/group/zps5164/default/abc6435/KROH/data/slim/rxy/results"

for i in {1..100}; do
    #RUN SIMULATION
    $slim -p $scripts/rxy_simulations_h00.slim

    #DATA WRANGLING
    cd $h00
    # Reheader Sample Names
    echo -e "i0_1929\ni1_1929\ni2_1929\ni3_1929\ni4_1929\ni5_1929" > 1929IDS.txt
    echo -e "i0_2009\ni1_2009\ni2_2009\ni3_2009\ni4_2009\ni5_2009\ni6_2009" > 2009IDS.txt
    bcftools reheader --samples 1929IDS.txt h00_1929.vcf -o h00_1929_reheadered_R${i}.vcf
    bcftools reheader --samples 2009IDS.txt h00_2009.vcf -o h00_2009_reheadered_R${i}.vcf

    #Zip and Index
    bgzip h00_1929_reheadered_R${i}.vcf
    bgzip h00_2009_reheadered_R${i}.vcf
    bcftools index h00_1929_reheadered_R${i}.vcf.gz
    bcftools index h00_2009_reheadered_R${i}.vcf.gz

    # Merge VCFs and Filter
    bcftools merge h00_1929_reheadered_R${i}.vcf.gz h00_2009_reheadered_R${i}.vcf.gz -Oz -o h00_R${i}.vcf.gz
    bcftools view -i 'F_MISSING == 0' h00_R${i}.vcf.gz -Oz -o h00_fmiss_R${i}.vcf.gz

    #file clean Up
    mv h00_1929_reheadered_R${i}.vcf.gz $eggs_folder
    mv h00_2009_reheadered_R${i}.vcf.gz $eggs_folder
    rm -rf *rehead* *.vcf *.csi h00_R${i}.vcf.gz

    #CALCULATE RXY
    # Define sites
    bcftools view -H -i 'INFO/S=0' h00_fmiss_R${i}.vcf.gz | cut -f 1,2 > s_0.txt
    bcftools view -H -i 'INFO/S>-0.05 && INFO/S<0' h00_fmiss_R${i}.vcf.gz | cut -f 1,2 > s_05_0.txt
    bcftools view -H -i 'INFO/S>-0.10 && INFO/S<-0.05' h00_fmiss_R${i}.vcf.gz | cut -f 1,2 > s_10_05.txt
    bcftools view -H -i 'INFO/S<-0.10' h00_fmiss_R${i}.vcf.gz | cut -f 1,2 > s_10.txt

    #Count Mutations
    s_0=$(wc -l s_0.txt | sed -e 's/[^0-9].*$//')
    s_05_0=$(wc -l s_05_0.txt | sed -e 's/[^0-9].*$//')
    s_10_05=$(wc -l s_10_05.txt | sed -e 's/[^0-9].*$//')
    s_10=$(wc -l s_10.txt | sed -e 's/[^0-9].*$//')

    awk -v rep="R${i}" \
        -v s_0="$s_0" \
        -v s_05_0="$s_05_0" \
        -v s_10_05="$s_10_05" \
        -v s_10="$s_10" \
        'BEGIN {print rep, "h00", s_0, s_05_0, s_10_05, s_10}' OFS="\t" \
        >> $results/s_counts.txt

    # Run Rxy-kin for each comparison
    $bin/Rxy-kin.py -v h00_fmiss_R${i}.vcf.gz -1 s_0.txt -2 s_05_0.txt -A 1929IDS.txt -B 2009IDS.txt \
    | awk -v rep="R${i}" '{print $0, "-0.05<s<0", "h00", rep}' OFS="\t" >> $results/rxy.txt

    $bin/Rxy-kin.py -v h00_fmiss_R${i}.vcf.gz -1 s_0.txt -2 s_10_05.txt -A 1929IDS.txt -B 2009IDS.txt \
    | awk -v rep="R${i}" '{print $0, "-0.10<s<-0.05", "h00", rep}' OFS="\t" >> $results/rxy.txt

    $bin/Rxy-kin.py -v h00_fmiss_R${i}.vcf.gz -1 s_0.txt -2 s_10.txt -A 1929IDS.txt -B 2009IDS.txt \
    | awk -v rep="R${i}" '{print $0, "s<-0.10", "h00", rep}' OFS="\t" >> $results/rxy.txt

    rm -rf *txt* h00_fmiss_R${i}.vcf.gz;
done