# Pixy
https://github.com/ksamuk/pixy

## Installation
```bash
#Load Python 3.11.2
module load python/3.11.2
module use python/3.11.2
python3 --version

#Create Virtual Environment 
mkdir -p /storage/home/abc6435/pixy_env
python3 -m venv /storage/home/abc6435/pixy_env
source /storage/home/abc6435/pixy_env/bin/activate

#Install Packages
pip install --upgrade pip
pip install numpy pandas scipy scikit-allel cyvcf2 typing_extensions

#Clone Pixy Repository
cd /storage/home/abc6435/SzpiechLab/bin
git clone https://github.com/ksamuk/pixy.git
cd pixy
pip install .

#Include in path
echo "export PATH=$HOME/pixy_env/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```