# GATK4

## Installation
```bash
#Install sdk
curl -s "https://get.sdkman.io" | bash
echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc

#Choose Java Version 17
cd /storage/home/abc6435/.sdkman/candidates/java
sdk list java
sdk install java 17.0.16-tem

echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.16-tem"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#Install GATK4 and add to bashrc
cd /storage/home/abc6435/SzpiechLab/bin
wget https://github.com/broadinstitute/gatk/releases/download/4.6.2.0/gatk-4.6.2.0.zip
unzip gatk-4.6.2.0.zip
rm -rf gatk-4.6.2.0.zip
echo 'export PATH=/storage/home/abc6435/SzpiechLab/bin/gatk-4.6.2.0:$PATH' >> ~/.bashrc
source ~/.bashrc
```

