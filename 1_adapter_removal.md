# Adapter Removal Pipeline
Using the AdapterRemoval program, we will remove  the adapters at the ends of our reads. The adapters are added to our DNA so that polymerase has a scaffold to start transcription during the PCR step. After transcription, our reads also get the transcribed adapters. But, we don't actually need the adapters and they need to be removed so we can preform our alignments later. To remove them, I employ a loop to go through each of our R1.fastq.gz and R2.fastq.gz files, and then apply the adapter removal tool. 
https://adapterremoval.readthedocs.io/en/stable/manpage.html

`AdapterRemoval --file1 R1.fq --file2 R2.fq --collapse --trimns --minlength 20 --qualitybase 33 --basename filepath/OUTPUT_trim`


![alt text](diagrams/adapter_removal.png)

- `--collapse`: collapses any regions where read 1 and read 2 overlap because the reads overlapped.
- `--trimns`: trims any base that was called as 'N'.
- `--minlength 20`: Filters out any reads less than 20bp
- `--qualitybase 33`: The input file is in phred 33 quality score
- `--gzip`: zip up the file
- `--basename`: specify location and name to store trimmed reads (aka the output file)


##  Adapter Removal Script
I employed a loop and parallel. The loop will echo the adapter removal tool command over all my samples and all those commands will get piped into parallel. 
```bash
nano WarblerROH_trim.bash
---------------------------NANO-----------------------
#!/bin/bash
#PBS -l feature=rhel7 
#PBS -l nodes=1:ppn=20
#PBS -l walltime=336:00:00
#PBS -l mem=1000gb
#PBS -A zps5164_a_g_hc_default

set -ue

for  i  in `cat ~/SzpiechLab/abc6435/Scripts/warbler_id_list.txt`; do echo " /storage/work/dut374/bin/adapterremoval-2.1.7/build/AdapterRemoval --file1 /storage/home/abc6435/SzpiechLab/abc6435/WarblerROH/${i}/${i}_R1.fastq.gz --file2 /storage/home/abc6435/SzpiechLab/abc6435/WarblerROH/${i}/${i}_R2.fastq.gz --collapse --trimns --minlength 20 --qualitybase 33 --gzip --basename /storage/home/abc6435/SzpiechLab/abc6435/WarblerROH/${i}/${i}_trimmed"; done | parallel -j20
--------------------EOS------------------------------
<CTRL O + Enter>
<CTRL X>
qsub WarblerROH_trim.bash
```

## Quality Control 
❌I didn't get a settings file. 
```bash
#Check if the paired reads are there and you should also have 21 settings files for each
for i in `cat ~/SzpiechLab/abc6435/Scripts/warbler_id_list.txt`; do ls -l ~/SzpiechLab/abc6435/WarblerROH/${i}/*pair*; done | wc -l
```

