#!/usr/bin/env python3

#Import Packages
import pandas as pd
import os
import numpy as np
import sys
import argparse

#Define RABmafs()
def RABmafs(popA_mut_sites, popB_mut_sites,
             popA_int_sites, popB_int_sites):
    #Checks file extensions (files must end in .maf)
    print("CHECKING FILE EXT...")
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
    print('DONE')

    #Imports Data
    print("IMPORTING DATA...")
    popA_mut = pd.read_csv(popA_mut_sites, sep='\t', header=(0))
    popB_mut = pd.read_csv(popB_mut_sites, sep='\t', header=(0))
    popA_int = pd.read_csv(popA_int_sites, sep='\t', header=(0))
    popB_int = pd.read_csv(popB_int_sites, sep='\t', header=(0))
    print("DONE")

    #Check Headers
    print("CHECKING HEADERS...")
    if not {'chromo', 'position', 'knownEM'}.issubset(popA_mut.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB_mut.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popA_int.columns):
        sys.exit("ERR: Check file headers")
    if not {'chromo', 'position', 'knownEM'}.issubset(popB_int.columns):
        sys.exit("ERR: Check file headers")
    else:
        print("DONE")
    
    #Checks Sites in PopA and PopB
    print("CHECKING SITES...")
    popA_mut_keys = popA_mut['chromo'].astype(str) + "_" + popA_mut['position'].astype(str)
    popB_mut_keys = popB_mut['chromo'].astype(str) + "_" + popB_mut['position'].astype(str)
    popA_int_keys = popA_int['chromo'].astype(str) + "_" + popA_int['position'].astype(str)
    popB_int_keys = popB_int['chromo'].astype(str) + "_" + popB_int['position'].astype(str)
    
    popA_mut_keys.equals(popB_mut_keys)
    popA_int_keys.equals(popB_int_keys)

    if len(popA_mut_keys)!= len(popB_mut_keys):
        sys.exit("ERR: Number of mutational sites in popA must be identical to popB")
    if len(popA_int_keys)!= len(popB_int_keys):
        sys.exit("ERR: Number of intergenic sites in popA must be identical to popB")
    if not popA_mut_keys.equals(popB_mut_keys):
        sys.exit("ERR: Mutational sites in popA and popB must be identical.")
    if not popA_int_keys.equals(popB_int_keys):
        sys.exit("ERR: Intergenic sites in popA and popB must be identical.")
    else:
        print('DONE')
    
    #Parse Data
    print("PARSING DATA...")
    f_AD = popA_mut['knownEM']
    f_BD = popB_mut['knownEM']
    f_AN = popA_int['knownEM']
    f_BN = popB_int['knownEM']
    print("DONE")

    #Calculate RAB
    print("CALCULATING RAB")
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_BN))
    RAB = LAB/LBA
    return print("RAB =",RAB)

#Argparse
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute RAB from .maf site files.")
    parser.add_argument("--popA_mut_sites", required=True, help="Pop A mutation sites (.maf)")
    parser.add_argument("--popB_mut_sites", required=True, help="Pop B mutation sites (.maf)")
    parser.add_argument("--popA_int_sites", required=True, help="Pop A intergenic sites (.maf)")
    parser.add_argument("--popB_int_sites", required=True, help="Pop B intergenic sites (.maf)")

    args = parser.parse_args()

#Run RABmafs() On Files Provided
    RABmafs(args.popA_mut_sites, args.popB_mut_sites, args.popA_int_sites, args.popB_int_sites)