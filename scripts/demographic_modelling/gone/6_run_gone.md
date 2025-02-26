# Run GONE

```bash
#Set Variables 
scripts_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/scripts"

nano $scripts_folder/run_gone_kirt.bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10GB
#SBATCH --time=5:00:00
#SBATCH --account=open
#SBATCH --partition=basic

#Setup
gone_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/gone"
sites="8M"
cd $gone_folder
mkdir $gone_folder/results

#Run GONE
bash script_GONE.sh $sites
sed -i '1d' Output_Ne_$sites
mv TEMPORARY_FILES/ TEMPORARY_FILES_$sites/
mv seedfile seedfile_$sites
mv timefile timefile_$sites
mv outfileHWD outfileHWD_$sites

mv OUTPUT_$sites Output_Ne_$sites Output_d2_$sites TEMPORARY_FILES_$sites/ $sites.map $sites.ped outfileHWD_$sites seedfile_$sites timefile_$sites $gone_folder/results
```