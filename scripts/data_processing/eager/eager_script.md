
# Eager Script

## Testing Nextflow
```bash
cd ~/SzpiechLab/abc6435/KROH/eager_test
NXF_VER=22.10.6 /storage/home/abc6435/SzpiechLab/abc6435/KROH/software/nextflow run nf-core/eager -profile test -r 2.4.7 singularity
```

## Eager Script
This script defines the locations of reference genomes, list of fastq files, alignment tool to be used and parameters. 
```bash
#Create a folder
KROH_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH"
if [ ! -d "$KROH_folder/eager_src" ]; then
    mkdir -p "$KROH_folder/eager_src"
fi


nano $KROH_folder/eager_src/eager_script_R_KIWA_NextSeq2000_WGS__30bp_q30Q30.sh
#---------------NANO--------------
NXF_VER=22.10.6 /storage/home/abc6435/SzpiechLab/abc6435/KROH/software/nextflow run nf-core/eager \
-r 2.4.7 \
-c eager_config_R_KIWA_NextSeq2000_WGS.sh \
-with-singularity \
-profile singularity \
-resume 'R_KIWA_bwa' \
--input 'R_KIWA_NextSeq2000_eager_sample_sheet_fastq.tsv' \
--fasta '/storage/group/dut374/default/mywa_genome_2/final_assembly/mywagenomev2.1.fa' \
--bwa_index '/storage/group/dut374/default/mywa_genome_2/final_assembly' \
--fasta_index '/storage/group/dut374/default/mywa_genome_2/final_assembly/mywagenomev2.1.fa.fai' \
--seq_dict '/storage/group/dut374/default/mywa_genome_2/final_assembly/mywagenomev2.1.dict' \
--outdir './results_30bpQ30q30/' \
--email 'abc6435@psu.edu' \
-w './work/' \
--complexity_filter_poly_g \
--clip_readlength 30 \
--clip_min_read_quality 30 \
--preserve5p \
--mergedonly \
--dedup_all_merged \
--dedupper 'dedup' \
--preseq_mode 'c_curve' \
--bwaalnn 0.01 \
--bwaalnl 1024 \
--bwaalno 2 \
--run_bam_filtering \
--bam_filter_minreadlength 30 \
--bam_mapping_quality_threshold 30 \
--bam_unmapped_type 'discard' \
#---------------EOS--------------
```