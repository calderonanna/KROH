# Create A List of FASTQS
Nextflow needs a list of fastqs. Create a tsv with the following headers

Sample_Name | Library_ID | Lane | Colour_Chemistry | SeqType Organism | Strandednes | UDG_Treatment | R1 | R2 | BAM
|--|--|--|--|--|--|--|--|--|--|
|sam_A|samA_LPXXX|L001|2 PE|genus_species|double|none|samA_R1_trimmed.fastq.gz|samA_R2_trimmed.fastq.gz|NA
|sam_B|samB_LPXXX|L001|2 PE|genus_species|double|none|samB_R1_trimmed.fastq.gz|samB_R2_trimmed.fastq.gz|NA
|sam_C|samC_LPXXX|L001|2 PE|genus_species|double|none|samC_R1_trimmed.fastq.gz|samC_R2_trimmed.fastq.gz|NA

```bash
nano $KROH_folder/eager_src/R_KIWA_NextSeq2000_eager_sample_sheet_fastq.tsv
#------------NANO----------
Sample_Name     Library_ID      Lane    Colour_Chemistry        SeqType Organism        Strandedness    UDG_Treatment   R1      R2      BAM
29779   29779_LPXXX     L001    2       PE      setophaga_kirtlandii    double  none    /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/trim/29779_R1_trimmed.fastq.gz   /storage/home/abc6435/SzpiechLab/abc6435/KROH/data/trim/29779_R2_trimmed.fastq.gz       NA
#------------EOS----------