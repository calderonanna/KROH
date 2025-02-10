```bash
#Set Variables
log_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/job_err_output"
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"
linux_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone/Linux"

sbatch $scripts_folder/run_gone.sh
# 4 SNP47263
```

## Subset example to only 4 chromosomes
```bash
awk '$1 == 1 || $1 == 2 || $1 == 3 || $1 == 4' example.map > example_subset.map

cut -f2 example_subset.map > example_subset_snp_list.txt

awk 'BEGIN {while (getline < "example_subset_snp_list.txt") snps[$1]=1} {for (i=7; i<=NF; i++) if ($i in snps) print $0}' example.ped > example_subset.ped
