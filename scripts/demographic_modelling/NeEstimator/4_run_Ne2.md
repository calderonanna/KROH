# Run Ne2
Running Ne2 will prompt you interactively, asking for: 
- The name of your GENEPOP input file
- Which Method to run


```bash
#Set Variables
Ne2="/storage/home/abc6435/SzpiechLab/bin/Ne2L"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

cd $work_dir

$Ne2
# > Input file name: 
data.gen 
# Which method(s) to run?
8
# For Temporal Method, enter number of samples (at least 2, max = 150):
6
# Enter generations for 6 samples
* for sample 1: 0
* for sample 2: 0.5
* for sample 3: 5
* for sample 4: 5.5
* for sample 5: 6.5
* for sample 6: 15.5
```