#!/usr/bin/env python3

#Import Packages
import pandas as pd
import numpy as np
import sys
import argparse

#Define readvcf()
def readvcf(vcf_file, pop_file, simulated_vcf=False):
    #Import Population File
    pops = pd.read_csv(pop_file, sep="\t", header=None)
    popA = pops[pops[0]=="popA"][1].astype(str)
    popB = pops[pops[0]=="popB"][1].astype(str)

    #Import VCF
    with open(vcf_file) as file:
        for line in file:
            if line.startswith('#CHROM'):
                cols = line.lstrip("#").strip().split("\t")
    data = pd.read_csv(vcf_file, sep='\t', comment='#', names=cols)

    #Extract Genotype Information
    loci = data[['CHROM','POS','REF','ALT']]
    samples = data.drop(columns=['CHROM', 'POS', 'REF', 'ALT','ID','QUAL','FILTER','INFO','FORMAT'])
    samples = samples.apply(lambda col: col.str.split(":").str[0])
    alleles = pd.concat([loci,samples], axis=1)

    #Count alleles
    aA = alleles[popA].astype(str)
    alleles['popA_0'] = aA.apply(lambda col: col.str.count('0')).sum(axis=1) 
    alleles['popA_1'] = aA.apply(lambda col: col.str.count('1')).sum(axis=1)
    aB = alleles[popB].astype(str)
    alleles['popB_0'] = aB.apply(lambda col: col.str.count('0')).sum(axis=1)
    alleles['popB_1'] = aB.apply(lambda col: col.str.count('1')).sum(axis=1)

    #Count Genotypes
    alleles['popA_hom'] = aA.apply(lambda col: col.str.count(r'1/1|1\|1')).sum(axis=1)
    alleles['popA_het'] = aA.apply(lambda col: col.str.count(r'0/1|0\|1|1/0|1\|0')).sum(axis=1)
    alleles['popB_hom'] = aB.apply(lambda col: col.str.count(r'1/1|1\|1')).sum(axis=1)
    alleles['popB_het'] = aB.apply(lambda col: col.str.count(r'0/1|0\|1|1/0|1\|0')).sum(axis=1)
           
    #Calculate Allele Frequencies (Empirical VCF)
    alleles['f_popA_0'] = alleles['popA_0']/(alleles['popA_0'] + alleles['popA_1'])
    alleles['f_popA_1'] = alleles['popA_1']/(alleles['popA_0'] + alleles['popA_1'])
    alleles['f_popB_0'] = alleles['popB_0']/(alleles['popB_0'] + alleles['popB_1'])
    alleles['f_popB_1'] = alleles['popB_1']/(alleles['popB_0'] + alleles['popB_1'])
    alleles['nA'] = (alleles['popA_0'] + alleles['popA_1']) / 2
    alleles['nB'] = (alleles['popB_0'] + alleles['popB_1']) / 2
    freq = alleles[['CHROM','POS','REF','ALT',
                      'f_popA_1','f_popB_1',
                      'popA_hom', 'popA_het',
                      'popB_hom', 'popB_het',
                      'nA','nB']].dropna(axis="rows")
    freq = freq[(freq["nA"] > 1) & (freq["nB"] > 1)]

    #Adjust Allele Frequencies for sites lost/gained (Simulated VCF)
    if simulated_vcf: 
        miss_popA = (alleles['popA_0'] == 0) & (alleles['popA_1'] == 0)
        alleles.loc[miss_popA, 'f_popA_0'] = 0
        alleles.loc[miss_popA, 'f_popA_1'] = 0
        miss_popB = (alleles['popB_0'] == 0) & (alleles['popB_1'] == 0)
        alleles.loc[miss_popB, 'f_popB_0'] = 0
        alleles.loc[miss_popB, 'f_popB_1'] = 0
        alleles.loc[miss_popA, 'nA'] = len(popA)
        alleles.loc[miss_popA, 'nB'] = len(popB)
        freq = alleles[['CHROM','POS','REF','ALT',
                      'f_popA_1','f_popB_1',
                      'popA_hom', 'popA_het',
                      'popB_hom', 'popB_het',
                      'nA','nB']]
    return freq

#Define importsites()
def importsites(neutral_file, mutation_file, derived_sites):
    neutral = pd.read_csv(neutral_file, sep='\t', header=(0))
    mutation = pd.read_csv(mutation_file, sep='\t', header=(0))
    neutral.rename(columns={'chromo':'CHROM', 'position':'POS'}, inplace=True)
    mutation.rename(columns={'chromo':'CHROM', 'position':'POS'}, inplace=True)
    neu_der = pd.merge(derived_sites, neutral, on=['CHROM','POS'],how='inner', indicator=True)
    mut_der = pd.merge(derived_sites, mutation, on=['CHROM','POS'],how='inner', indicator=True)
    neu_der = neu_der[neu_der['_merge']=='both'].drop(columns=['_merge'])
    mut_der = mut_der[mut_der['_merge']=='both'].drop(columns=['_merge'])
    return neu_der, mut_der

#Define calcRAB()
def calcRAB(neu_der, mut_der, seed):
    np.random.seed(seed)
    index1=np.random.permutation(len(neu_der))[:10000]
    neu1=neu_der.iloc[index1]
    f_AD = mut_der['f_popA_1']
    f_BD = mut_der['f_popB_1']
    f_AN = neu1['f_popA_1']
    f_BN = neu1['f_popB_1']
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
    f_AD = neu1['f_popA_1']
    f_BD = neu1['f_popB_1']
    f_AN = neu2['f_popA_1']
    f_BN = neu2['f_popB_1']
    LAB = sum(f_AD*(1-f_BD))/sum(f_AN*(1-f_BN))
    LBA = sum(f_BD*(1-f_AD))/sum(f_BN*(1-f_AN))
    RAB_neu = LAB/LBA
    return RAB_neu

#Define calcRAB_subs()
def calcRAB_sub(neu_sub, mut_sub):
    index1=np.random.permutation(len(neu_sub))[:10000]
    neu1=neu_sub.iloc[index1]
    f_AD = mut_sub['f_popA_1']
    f_BD = mut_sub['f_popB_1']
    f_AN = neu1['f_popA_1']
    f_BN = neu1['f_popB_1']
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

#Define bootstrap()
def bootstrap(neu_der, mut_der, psites, iter):
    bts = []
    for i in range(iter):
        neu_sub = samplesites(neu_der, psites)
        mut_sub = samplesites(mut_der, psites)
        bts.append(calcRAB_sub(neu_sub, mut_sub))
    return np.array(bts)
    
#Argparse
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute RAB from .vcf file.")
    parser.add_argument("--vcf", required=True, help="VCF file should contain only derived sites")
    parser.add_argument("--pop", required=True, help="tab seperated file. Column 1 denotes population ID (popA or popB) and colum 2 are sample names. ")
    parser.add_argument("--fileN", required=True, help="tab separated list of neutral sites. Column 1 should be labelled 'chromo' and column 2 should be labelled 'position'")
    parser.add_argument("--fileM", required=True, help="tab separated list of mutation sites (e.g, lof). Column 1 should be labelled 'chromo' and column 2 should be labelled 'position'")
    parser.add_argument("--seed", required=True, type=int, help="Set seed for subsampling 10000 neutral sites.")
    parser.add_argument("--psites", required=True, type=float, help="Proportion of sites to retain for bootstrap (e.g: 0.90 for 90%)")
    parser.add_argument("--iter", required=True, type=int, help="Number of iterations for bootstraps.")
    parser.add_argument("--simulated_vcf", action="store_true", help="Set if the VCF is simulated")
    args = parser.parse_args()
#Run
der = readvcf(args.vcf, args.pop, args.simulated_vcf)
neu_der, mut_der = importsites(args.fileN, args.fileM, der)
bts_array = bootstrap(neu_der, mut_der, float(args.psites), int(args.iter))
q025, q975 = np.percentile(bts_array, [2.5, 97.5])
avg = np.mean(bts_array)

#Report Number of Sites 
print("N_Sites = ", len(mut_der))

#Report Genotype Counts
print("PopA Homozygotes = ", mut_der['popA_hom'].sum())
print("PopA Heterozygotes = ", mut_der['popA_het'].sum())
print("PopB Homozygotes = ", mut_der['popB_hom'].sum())
print("PopB Heterozygotes = ", mut_der['popB_het'].sum())

#Report RAB Results
print("RAB =", calcRAB(neu_der, mut_der, args.seed))
print("avg[2.5%,97.5%] = ", avg,"[",q025,",",q975,"]")
print("RAB_neutral = ", calcRAB_neu(neu_der, args.seed))