#!/usr/bin/env python3

#Import Packages
import pandas as pd
import os
import numpy as np
import sys
import argparse

#Define readmafs()
def readmafs(popA_mut_sites, popB_mut_sites, popA_int_sites, popB_int_sites):
    #Checks file extensions (files must end in .maf)
    f1 = popA_mut_sites.split(".")
    if f1[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")
    f2 = popB_mut_sites.split(".")
    if f2[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")
    f3 = popA_int_sites.split(".")
    if f3[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")
    f4 = popB_int_sites.split(".")
    if f4[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")

    #Imports Data
    popA_mut = pd.read_csv(popA_mut_sites, sep='\t', header=(0))
    popB_mut = pd.read_csv(popB_mut_sites, sep='\t', header=(0))
    popA_int = pd.read_csv(popA_int_sites, sep='\t', header=(0))
    popB_int = pd.read_csv(popB_int_sites, sep='\t', header=(0))

    #Check Headers
    if not {'chromo', 'position', 'knownEM'}.issubset(popA_mut.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB_mut.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popA_int.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB_int.columns):
        sys.exit("ERR: Check file headers")
    
    #Checks Sites in PopA and PopB
    popA_mut_keys = popA_mut['chromo'].astype(str) + "_" + popA_mut['position'].astype(str)
    popB_mut_keys = popB_mut['chromo'].astype(str) + "_" + popB_mut['position'].astype(str)
    popA_int_keys = popA_int['chromo'].astype(str) + "_" + popA_int['position'].astype(str)
    popB_int_keys = popB_int['chromo'].astype(str) + "_" + popB_int['position'].astype(str)

    if not popA_mut_keys.equals(popB_mut_keys):
        sys.exit("ERR: Mutational sites in popA and popB must be identical.")
    if not popA_int_keys.equals(popB_int_keys):
        sys.exit("ERR: Intergenic sites in popA and popB must be identical.")
    else:
        return popA_mut, popB_mut, popA_int, popB_int

#Define parsemafs()
def parsemafs(popA_mut, popB_mut, popA_int, popB_int):
    #Parse Data
    f_AD = popA_mut['knownEM']
    f_BD = popB_mut['knownEM']
    f_AN = popA_int['knownEM']
    f_BN = popB_int['knownEM']
    return f_AD, f_BD, f_AN, f_BN

#Define calcRAB()
def calcRAB(f_AD, f_BD, f_AN, f_BN):
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_BN))
    RAB = LAB/LBA
    return RAB

#Define samplemafs()
def samplemafs(popA_sites, popB_sites, Psites):
    #Subsample Sites
    Nsites = int(round(len(popA_sites) * Psites))
    sites = np.random.permutation(len(popA_sites))[:Nsites]
    popA_sites_subsamp = popA_sites.iloc[sites]
    popB_sites_subsamp = popB_sites.iloc[sites]

    return popA_sites_subsamp, popB_sites_subsamp

#Define jackknife()
def jackknife(popA_mut, popB_mut, popA_int, popB_int, Psites, iter):
    jx = []
    for i in range(iter):
        popA_mut_subsamp, popB_mut_subsamp = samplemafs(popA_mut, popB_mut, Psites)
        popA_int_subsamp, popB_int_subsamp = samplemafs(popA_int, popB_int, Psites)
        
        f_sub_AD, f_sub_BD, f_sub_AN, f_sub_BN = parsemafs(popA_mut_subsamp, 
                                                           popB_mut_subsamp,
                                                           popA_int_subsamp,
                                                           popB_int_subsamp)
        jx.append(calcRAB(f_sub_AD, f_sub_BD, f_sub_AN, f_sub_BN))
    return np.array(jx)

#Argparse
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute RAB from .maf site files.")
    parser.add_argument("--popA_mut_sites", required=True, help="Pop A mutation sites (.maf)")
    parser.add_argument("--popB_mut_sites", required=True, help="Pop B mutation sites (.maf)")
    parser.add_argument("--popA_int_sites", required=True, help="Pop A intergenic sites (.maf)")
    parser.add_argument("--popB_int_sites", required=True, help="Pop B intergenic sites (.maf)")
    parser.add_argument("--Psites", required=True, type=float, help="Proportion of sites to keep for jackknife (e.g: 0.90)")
    parser.add_argument("--iter", required=True, type=int, help="Number of iteration for jackknife")
    
    args = parser.parse_args()

#Calculate RAB
popA_mut, popB_mut, popA_int, popB_int = readmafs(args.popA_mut_sites, 
                                                    args.popB_mut_sites, 
                                                    args.popA_int_sites, 
                                                    args.popB_int_sites)
f_AD, f_BD, f_AN, f_BN = parsemafs(popA_mut, popB_mut, popA_int, popB_int)
print("RAB =", calcRAB(f_AD, f_BD, f_AN, f_BN))

#SUBSAMPLE AND JACKKNIFE
jx_array = jackknife(popA_mut, popB_mut, popA_int, popB_int, 
                     float(args.Psites), int(args.iter))
q025, q975 = np.percentile(jx_array, [2.5, 97.5])
print("2.5% =", q025)
print("97.5% =", q975)