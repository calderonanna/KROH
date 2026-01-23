#!/usr/bin/env python3

#Import Packages
import pandas as pd
import numpy as np
import sys
import argparse

#Define readmafs()
def readmafs(fileA, fileB, fileN, fileM):
    #Checks file extensions (files must end in .maf)
    f1 = fileA.split(".")
    if f1[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")
    f2 = fileB.split(".")
    if f2[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")

    #Imports Data
    popA = pd.read_csv(fileA, sep='\t', header=(0))
    popB = pd.read_csv(fileB, sep='\t', header=(0))
    neutral = pd.read_csv(fileN, sep='\t', header=(0))
    mutation = pd.read_csv(fileM, sep='\t', header=(0))

    #Check Headers
    if not {'chromo', 'position', 'knownEM'}.issubset(popA.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position'}.issubset(neutral.columns):
        sys.exit("ERR: Check file headers.")
    if not {'chromo', 'position'}.issubset(mutation.columns):
        sys.exit("ERR: Check file headers")

    #Join popA and popB 
    der = pd.merge(popA, popB, on=['chromo','position','major','minor','ref'],how='inner')
    neu_der = pd.merge(der, neutral, on=['chromo','position'],how='inner', indicator=True)
    mut_der = pd.merge(der, mutation, on=['chromo','position'],how='inner', indicator=True)
    neu_der = neu_der[neu_der['_merge']=='both'].drop(columns=['_merge'])
    mut_der = mut_der[mut_der['_merge']=='both'].drop(columns=['_merge'])
    print("Number of derived mutations =", len(mut_der))
    return neu_der, mut_der

#Define calcRAB()
def calcRAB(neu_der, mut_der, seed):
    np.random.seed(seed)
    index1=np.random.permutation(len(neu_der))[:10000]
    neu1=neu_der.iloc[index1]
    f_AD = mut_der['knownEM_x']
    f_BD = mut_der['knownEM_y']
    f_AN = neu1['knownEM_x']
    f_BN = neu1['knownEM_y']
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_AN))
    RAB = LAB/LBA
    return RAB

#Define calcRAB_neu()
def calcRAB_neu(neu_der, seed):
    np.random.seed(seed)
    index1=np.random.permutation(len(neu_der))[:10000]
    neu1=neu_der.iloc[index1]
    index2=np.random.permutation(len(neu_der))[:10000]
    neu2=neu_der.iloc[index2]
    f_AD = neu1['knownEM_x']
    f_BD = neu1['knownEM_y']
    f_AN = neu2['knownEM_x']
    f_BN = neu2['knownEM_y']
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_AN))
    RAB_neu = LAB/LBA
    return RAB_neu

#Define calcRAB_subs()
def calcRAB_sub(neu_sub, mut_sub):
    index1=np.random.permutation(len(neu_sub))[:10000]
    neu1=neu_sub.iloc[index1]
    f_AD = mut_sub['knownEM_x']
    f_BD = mut_sub['knownEM_y']
    f_AN = neu1['knownEM_x']
    f_BN = neu1['knownEM_y']
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_AN))
    RAB_sub = LAB/LBA
    return RAB_sub

#Define samplesites()
def samplesites(sites, psites):
    nsites = int(round(len(sites) * psites))
    indices = np.random.permutation(len(sites))[:nsites]
    subsamp = sites.iloc[indices]
    return subsamp

#Define jackknife()
def jackknife(neu_der, mut_der, psites, iter):
    jx = []
    for i in range(iter):
        neu_sub = samplesites(neu_der, psites)
        mut_sub = samplesites(mut_der, psites)
        jx.append(calcRAB_sub(neu_sub, mut_sub))
    return np.array(jx)

#Argparse
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute RAB from .maf site files.")
    parser.add_argument("--fileA", required=True, help="popA.maf; a list of derived sites in pop A")
    parser.add_argument("--fileB", required=True, help="popB.maf; a list of derived sites in pop B")
    parser.add_argument("--fileN", required=True, help="tab separated list of neutral sites. Column 1 should be labelled 'chromo' and column 2 should be labelled 'position'")
    parser.add_argument("--fileM", required=True, help="tab separated list of mutation sites (e.g, lof). Column 1 should be labelled 'chromo' and column 2 should be labelled 'position'")
    parser.add_argument("--seed", required=True, type=int, help="Set seed for subsampling 10000 intergenic sites.")
    parser.add_argument("--psites", required=True, type=float, help="Proportion of sites to retain for jackknife (e.g: 0.90 for 90%)")
    parser.add_argument("--iter", required=True, type=int, help="Number of iterations for jackknife.")
    args = parser.parse_args()

#RUN
neu_der, mut_der = readmafs(args.fileA, args.fileB, args.fileN, args.fileM)
jx_array = jackknife(neu_der, mut_der, float(args.psites), int(args.iter))
q025, q975 = np.percentile(jx_array, [2.5, 97.5])
avg = np.mean(jx_array)

print("RAB =", calcRAB(neu_der, mut_der, args.seed))
print("avg[2.5%,97.5%] = ", avg,"[",q025,",",q975,"]")
print("RAB_neutral = ", calcRAB_neu(neu_der, args.seed))