# Convert VCF to Genepop Format

## Create .spid
```bash
#Set Variables
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

nano $work_dir/vcf_to_genepop.spid
# spid-file generated: Wed Apr 23 17:23:37 EDT 2025
# VCF Parser questions
PARSER_FORMAT=VCF
# Only output SNPs with a phred-scaled quality of at least:
VCF_PARSER_QUAL_QUESTION=
# Include a file with population definitions:
VCF_PARSER_POP_FILE_QUESTION=
# What is the ploidy of the data? (DIPLOID/HAPLOID)
VCF_PARSER_PLOIDY_QUESTION=DIPLOID
# Output genotypes as missing if the phred-scale genotype quality is below:
VCF_PARSER_GTQUAL_QUESTION=
# Do you want to include INDELS as STANDARD genetic markers? (TRUE/FALSE)
VCF_PARSER_INDEL_QUESTION=false
# Do you want to include non-polymorphic SNPs? (TRUE/FALSE)
VCF_PARSER_MONOMORPHIC_QUESTION=false
# Only output following individuals (ind1, ind2, ind4, ...):
VCF_PARSER_IND_QUESTION=
# Only input following regions (refSeqName:start:end, multiple regions: whitespace separated):
VCF_PARSER_REGION_QUESTION=
# Output genotypes as missing if the read depth of a position for the sample is below:
VCF_PARSER_READ_QUESTION=
# Take most likely genotype if "PL" or "GL" is given in the genotype field? (TRUE/FALSE)
VCF_PARSER_PL_QUESTION=true
# Do you want to exclude loci with only missing data? (TRUE/FALSE)
VCF_PARSER_EXC_MISSING_LOCI_QUESTION=true
# GENEPOP Writer questions
WRITER_FORMAT=GENEPOP
# Specify which data type should be included in the GENEPOP file  (GENEPOP can only analyze one data type per file): (MICROSAT/STANDARD/SNP/DNA)
GENEPOP_WRITER_DATA_TYPE_QUESTION=SNP
# If SNP data are encoded as nucleotides,  enter the integers that code for nucleotide A, T, C, G (comma separated, e.g 1,2,3,4):
GENEPOP_WRITER_SNP_CODE_QUESTION=
```

## Run PGDSpider3
```bash
#Set Variables
pgdspider="/storage/home/abc6435/SzpiechLab/bin/PGDSpider_3.0.0.0/PGDSpider3-cli.jar"
vcf="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne/hKIWA_tags_auto_bi_gtdp_gtgq_nmiss_poly.vcf"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

bgzip -d $vcf.gz

java -Xmx4G -jar $pgdspider \
  -inFile $vcf \
  -inFormat VCF \
  -outFile $work_dir/hKIWA_data.gen \
  -outFormat GENEPOP \
  -spid $work_dir/vcf_to_genepop.spid