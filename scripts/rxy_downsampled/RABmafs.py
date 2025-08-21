#!/usr/bin/env python3

#Import Packages
import pandas as pd
import numpy as np
import sys
import argparse

#Define readmafs()
def readmafs(popA_derived, popB_derived, intergenic_sites, mutation_sites, seed):
    #Checks file extensions (files must end in .maf)
    f1 = popA_derived.split(".")
    if f1[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")
    f2 = popB_derived.split(".")
    if f2[-1] == "gz":
        sys.exit("ERR: MAF file should be unzipped")

    #Imports Data
    popA_der = pd.read_csv(popA_derived, sep='\t', header=(0))
    popB_der = pd.read_csv(popB_derived, sep='\t', header=(0))
    inter = pd.read_csv(intergenic_sites, sep='\t', header=(0))
    mut = pd.read_csv(mutation_sites, sep='\t', header=(0))

    #Check Headers
    if not {'chromo', 'position', 'knownEM'}.issubset(popA_der.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB_der.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position'}.issubset(inter.columns):
        sys.exit("ERR: Check file headers.")
    if not {'chromo', 'position'}.issubset(mut.columns):
        sys.exit("ERR: Check file headers")

    #Join popA and popB Derived Sites
    derived = pd.merge(popA_der,
                       popB_der,
                       on=['chromo','position','major','minor','ref'],
                       how='inner')
    
    #Extract 10K Derived Intergenic Sites
    int_der = pd.merge(derived,
                   inter,
                   on=['chromo','position'],
                   how='inner')
    
    np.random.seed(seed)
    indices_int = np.random.permutation(len(int_der))[:10000]
    int_der_10K = int_der.iloc[indices_int]
    
    #Extract Derived Mutations
    mut_der = pd.merge(derived,
                   mut,
                   on=['chromo','position'],
                   how='inner')
    return int_der_10K, mut_der

#Define parsemafs()
def parsemafs(int_der_10K, mut_der):
    #Parse Data
    f_AD = mut_der['knownEM_x']
    f_BD = mut_der['knownEM_y']
    f_AN = int_der_10K['knownEM_x']
    f_BN = int_der_10K['knownEM_y']
    return f_AD, f_BD, f_AN, f_BN

#Define calcRAB()
def calcRAB(f_AD, f_BD, f_AN, f_BN):
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_BN))
    RAB = LAB/LBA
    return RAB

#Define samplesites()
def samplesites(sites, Psites):
    #Subsample Sites
    Nsites = int(round(len(sites) * Psites))
    indices = np.random.permutation(len(sites))[:Nsites]
    sites_subsamp = sites.iloc[indices]
    return sites_subsamp

#Define jackknife()
def jackknife(int_der, mut_der, Psites, iter):
    jx = []
    for i in range(iter):
        int_subsamp = samplesites(int_der, Psites)
        mut_subsamp = samplesites(mut_der, Psites)
        f_sub_AD, f_sub_BD, f_sub_AN, f_sub_BN = parsemafs(int_subsamp, mut_subsamp)
        jx.append(calcRAB(f_sub_AD, f_sub_BD, f_sub_AN, f_sub_BN))
    return np.array(jx)

#Argparse
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute RAB from .maf site files.")
    parser.add_argument("--popA_derived", required=True, help="Pop A derived mutation sites (.maf)")
    parser.add_argument("--popB_derived", required=True, help="Pop B derived mutation sites (.maf)")
    parser.add_argument("--intergenic_sites", required=True, help="tab separated list of intergenic sites. Column 1 should be labelled chromo and column 2 should be labelled 'position'")
    parser.add_argument("--mutation_sites", required=True, help="tab separated list of mutation sites (e.g, lof). Column 1 should be labelled chromo and column 2 should be labelled 'position'")
    parser.add_argument("--seed", required=True, type=int, help="Set seed for subsampling 10000 intergenic sites.")
    parser.add_argument("--Psites", required=True, type=float, help="Proportion of sites to retain for jackknife (e.g: 0.90 for 90%)")
    parser.add_argument("--iter", required=True, type=int, help="Number of iterations for jackknife.")
    args = parser.parse_args()

#CALCULATE RAB
inter, muts = readmafs(args.popA_derived,
                       args.popB_derived,
                       args.intergenic_sites,
                       args.mutation_sites,
                       int(args.seed))

f_AD, f_BD, f_AN, f_BN = parsemafs(inter, muts)

print("RAB =", calcRAB(f_AD, f_BD, f_AN, f_BN))

#SUBSAMPLE AND JACKKNIFE
jx_array = jackknife(inter,
                     muts,
                     float(args.Psites),
                     int(args.iter))

q025, q975 = np.percentile(jx_array, [2.5, 97.5])

print("2.5% =", q025)
print("97.5% =", q975)