# Run Ne Estimator (GUI)

## Download GENEPOP
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rldne/KIWA_data.gen /Users/abc6435/Desktop/KROH/data/rldne

## Launch GUI
Run Ne Estimator with the following presets:
- Data Fromat: GENEPOP
- Temporal, Plan II
    0,53
- Critical Values: 0.05, 0.02, 0.01 (screens out rare alleles above these thresholds)
```bash
/Users/abc6435/Desktop
java -jar NeEstimator2x.jar