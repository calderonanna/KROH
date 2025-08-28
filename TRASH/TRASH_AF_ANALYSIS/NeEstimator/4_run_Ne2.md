# Run Ne2
Running Ne2 will prompt you interactively, asking for: 
- The name of your GENEPOP input file
- Which Method to run

## Create a Parameter File
```bash
Ne2="/storage/home/abc6435/SzpiechLab/bin/Ne2L"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

nano $work_dir/info.txt
1 * A number = sum of method(s) to run: LD(=1), Het(=2), Coan(=4), Temporal(=8).
/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne/ * Input Directory
data.gen * Input file name
2 * 1 = FSTAT format, 2 = GENEPOP format
/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne/ * Output Directory
dataTP.txt * Output file name (put asterisk adjacent to the name to append)
3   * Number of critical values, added 1 if a run by rejecting only singleton alleles is included
0.05  0.02  0.01 * Critical values, a special value '1' is for rejecting only singleton alleles
1 * 0: Random mating, 1: Monogamy (LD method)
#0 0 0.5 * One set of generations per line. The first entry is N > 0 for plan I, 0 for plan II.
#0 5 5.5 6.5 15.5 * One set of generations per line. The first entry is N > 0 for plan I, 0 for plan II
```

## Run Ne Estimator
```bash
#Set Variables
Ne2="/storage/home/abc6435/SzpiechLab/bin/Ne2L"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne"

#Run
cd $work_dir
$Ne2 i:info.txt 
```