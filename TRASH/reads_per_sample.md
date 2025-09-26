```bash
samtools view -F 0x904 L_atlanticus_BBIP_2_S1_marked.bam | awk '{ contig = $3; read_len = length($10); sum[contig] += read_len } END { for (c in sum) print c, sum[c] }' | sort >> mapped_bases.txt 
#OZ118746.1 3354101612

samtools view -F 0xd04 L_atlanticus_BBIP_2_S1_marked.bam | \
awk '{ contig = $3; read_len = length($10); sum[contig] += read_len } END { for (c in sum) print c, sum[c] }' | \
sort >> mapped_bases_deduplicated.txt

qualimap bamqc -bam L_atlanticus_BBIP_2_S1_marked.bam --skip-duplicates --min-mapping-quality 0 --min-base-quality 0 -outdir qualimap_BBIP_2_filtered

nano qualimapBBIP_2_filtered.sh
#!/bin/bash
#SBATCH --account=dut374_sc_default
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --time=1:00:00
#SBATCH --mem=10GB
#SBATCH --output=output_file_%j.txt
#SBATCH --job-name=quali

module use /storage/group/dut374/default/sw/modules
module load all

cd /storage/home/abc6435/ToewsLab/helaina/data/bam

qualimap bamqc -bam L_atlanticus_BBIP_2_S1_marked.bam --skip-duplicates --min-mapping-quality 0 --min-base-quality 0 -outdir qualimap_BBIP_2_filtered
