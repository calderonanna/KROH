# Rohmu

Rohmu is the number of "heterozygous sites" in an ROH the user is willing to tolerate within a given window. For example, in a 50Kb window and an rohmu of 5e-5, the number of tolerated hets is 2 (1000000 * 2e-6). This can be arbitary, so it will need adjusting. Following the github issues page (https://github.com/grenaud/ROHan/issues/12?utm_source=chatgpt.com), these are Gabriel's suggestions

1. Run ROHan with a default --rohmu
2. Look at a PDF with the different states of the hidden markov model
3. Do you see clear runs of homozygosity that don't get flagged as ROHs? Then you might need to increase rohmu.
4. Do you see regions that are clearly not ROH that get flagged as ROH? If so, you need to decrease rohmu

## Inspect .hmm.pdf
```bash
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan/results/rohmu_1e-3_1Mb/183195332.hmm_1_3.pdf  /Users/abc6435/Desktop

rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rohan/results/183195332.het_*.pdf /Users/abc6435/Desktop