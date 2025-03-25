#!/usr/bin/env Rscript

#Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)

#Check if the user provided all necessary arguments
if (length(args) < 5) {
  stop("Error: Missing arguments.\nUsage: 
  ./interpolate_map.R 
  <input_file> 
  <chromosome_number> 
  <chromosome_length>
  <output_directory> 
  <library_path>\n")
}

#Assign command-line arguments
#First argument: input file
input_file <- args[1]
#Second argument: chromosome number
chr_number <- as.numeric(args[2])
#Third argument: chromsome length
chr_length <- as.numeric(args[3])
#Fourth argument
output_dir <- args[4]
#Fifth argument: custom library path
r_lib_path <- args[5]

##########
#Load necessary libraries
library(dplyr, lib.loc = r_lib_path)
library(zoo, lib.loc = r_lib_path)

#Read Map File
map <- read.table(
  input_file,
  header = FALSE,
  sep = "",
  col.names = c("CHR", "SNP", "cMMb", "POS")
)

#subset the specified chromosome
chr_map <- subset(map, CHR == chr_number)

#check if the specified chromosome exists in the data
if (nrow(chr_map) == 0) {
  stop(paste("Error: No data found for chromosome", chr_number, "\n"))
}

#Create DF of chromosome's length
chr <- data.frame(
  CHR = chr_number,
  POS = seq(1, chr_length, 1)
)

#Merge with map data
merged <- merge(chr, chr_map, all.x = TRUE)

#Set first cMMb value to 0
merged[1, "cMMb"] <- 0

#interpolate cMMb, handling missing values
int_df <- as.data.frame(
  approx(
    merged$POS,
    merged$cMMb,
    method = "linear",
    n = nrow(merged)
  )
)

#Create a new DF with all info columns
int_map <- data.frame(
  CHR = merged$CHR,
  SNP = merged$SNP,
  cMMb = int_df$y,
  POS = merged$POS
)


#Define output filename
output_file <- file.path(output_dir, paste0("chr", chr_number, "int.map"))

#Export the interpolated map file as tab-separated
write.table(
  int_map,
  output_file,
  sep = "\t",
  row.names = FALSE,
  quote = FALSE,
  na = "NA"
)

#Print completion message
cat(paste("Interpolation complete. File saved as", output_file, "\n"))