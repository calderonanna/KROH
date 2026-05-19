# ROHan
https://github.com/grenaud/ROHan

## Installation
```bash
#Set Variables
bin="/storage/home/abc6435/SzpiechLab/bin"

# Clone ROHan
git clone --depth 1 https://github.com/grenaud/rohan.git
cd rohan
make

# bam2prof didn't install correctly
cd bam2prof
nano make
#change CXXFLAGS = -std=c++11 to CXXFLAGS = -std=c++17
make clean
make
```

