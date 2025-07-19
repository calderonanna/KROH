# Clean Up 
Ensure that cKIWA and hKIWA have identical derived mutations. 

## Count Muts
There are likely more mutations in cKIWA than hKIWA. 
```bash
# Loss of Function
$ wc -l *loss*
  752 cKIWA_der_lossoffunction.temp
  745 hKIWA_der_lossoffunction.temp

cut -f 8 hKIWA_der_lossoffunction.temp >> $basedir/derived_mutations/mut_counts/lof_counts.txt
cut -f 8 cKIWA_der_lossoffunction.temp >> $basedir/derived_mutations/mut_counts/lof_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/lof_counts.txt >> $basedir/derived_mutations/mut_counts/rm_lof_cKWIA.txt

# Deleterious
$ wc -l *del*
  14290 cKIWA_der_deleterious.temp
  14217 hKIWA_der_deleterious.temp

cut -f 8 hKIWA_der_deleterious.temp >> $basedir/derived_mutations/mut_counts/del_counts.txt
cut -f 8 cKIWA_der_deleterious.temp >> $basedir/derived_mutations/mut_counts/del_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/del_counts.txt >> $basedir/derived_mutations/mut_counts/rm_del_cKWIA.txt

# Noncoding (154)
$ wc -l *noncod*
  38781 cKIWA_der_noncoding.temp
  38627 hKIWA_der_noncoding.temp

cut -f 8 hKIWA_der_noncoding.temp >> $basedir/derived_mutations/mut_counts/noncode_counts.txt
cut -f 8 cKIWA_der_noncoding.temp >> $basedir/derived_mutations/mut_counts/noncode_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/noncode_counts.txt >> $basedir/derived_mutations/mut_counts/rm_noncode_cKWIA.txt

# Nonsyn (147)
$ wc -l *nonsyn*      
  33782 cKIWA_der_nonsynonymous.temp
  33635 hKIWA_der_nonsynonymous.temp
  67417 total

cut -f 8 hKIWA_der_nonsynonymous.temp >> $basedir/derived_mutations/mut_counts/nonsyn_counts.txt
cut -f 8 cKIWA_der_nonsynonymous.temp >> $basedir/derived_mutations/mut_counts/nonsyn_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/nonsyn_counts.txt >> $basedir/derived_mutations/mut_counts/rm_nonsyn_cKWIA.txt

# Syn (123)
$ wc -l *_syn*
  46568 cKIWA_der_synonymous.temp
  46445 hKIWA_der_synonymous.temp
  93013 total

cut -f 8 hKIWA_der_synonymous.temp >> $basedir/derived_mutations/mut_counts/syn_counts.txt
cut -f 8 cKIWA_der_synonymous.temp >> $basedir/derived_mutations/mut_counts/syn_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/syn_counts.txt >> $basedir/derived_mutations/mut_counts/rm_syn_cKWIA.txt

# Tol (182)
$ wc -l *tol*
  64798 cKIWA_der_tolerated.temp
  64616 hKIWA_der_tolerated.temp
 129414 total

cut -f 8 hKIWA_der_tolerated.temp >> $basedir/derived_mutations/mut_counts/tol_counts.txt
cut -f 8 cKIWA_der_tolerated.temp >> $basedir/derived_mutations/mut_counts/tol_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/tol_counts.txt >> $basedir/derived_mutations/mut_counts/rm_tol_cKWIA.txt

# Inter1 (49)
$ wc -l *intergenic1*
 10000 cKIWA_der_intergenic1.temp
  9951 hKIWA_der_intergenic1.temp
 19951 total

cut -f 8 hKIWA_der_intergenic1.temp >> $basedir/derived_mutations/mut_counts/inter1_counts.txt
cut -f 8 cKIWA_der_intergenic1.temp >> $basedir/derived_mutations/mut_counts/inter1_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/inter1_counts.txt >> $basedir/derived_mutations/mut_counts/rm_inter1_cKWIA.txt

# Inter2 (67)
$ wc -l *intergenic2*
 10000 cKIWA_der_intergenic2.temp
  9933 hKIWA_der_intergenic2.temp
 19933 total

cut -f 8 hKIWA_der_intergenic2.temp >> $basedir/derived_mutations/mut_counts/inter2_counts.txt
cut -f 8 cKIWA_der_intergenic2.temp >> $basedir/derived_mutations/mut_counts/inter2_counts.txt

awk '{count[$1]++} END {for (id in count) if (count[id] == 1) print id}' $basedir/derived_mutations/mut_counts/inter2_counts.txt >> $basedir/derived_mutations/mut_counts/rm_inter2_cKWIA.txt

wc -l $basedir/derived_mutations/mut_counts/rm_inter2_cKWIA.txt
```

## Remove Excess Muts From cKIWA
```bash
#DEL
grep -vFf $basedir/derived_mutations/mut_counts/rm_del_cKWIA.txt $basedir/derived_mutations/cKIWA_der_deleterious.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_deleterious.maf

#TOL
grep -vFf $basedir/derived_mutations/mut_counts/rm_tol_cKWIA.txt $basedir/derived_mutations/cKIWA_der_tolerated.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_tolerated.maf

#LOF
grep -vFf $basedir/derived_mutations/mut_counts/rm_lof_cKWIA.txt $basedir/derived_mutations/cKIWA_der_lossoffunction.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_lossoffunction.maf

#SYN
grep -vFf $basedir/derived_mutations/mut_counts/rm_syn_cKWIA.txt $basedir/derived_mutations/cKIWA_der_synonymous.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_synonymous.maf

#NONSYN
grep -vFf $basedir/derived_mutations/mut_counts/rm_nonsyn_cKWIA.txt $basedir/derived_mutations/cKIWA_der_nonsynonymous.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_nonsynonymous.maf

#NONCODE
grep -vFf $basedir/derived_mutations/mut_counts/rm_noncode_cKWIA.txt $basedir/derived_mutations/cKIWA_der_noncoding.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_noncoding.maf

#INTER1
grep -vFf $basedir/derived_mutations/mut_counts/rm_inter1_cKWIA.txt $basedir/derived_mutations/cKIWA_der_intergenic1.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_intergenic1.maf

#INTER2
grep -vFf $basedir/derived_mutations/mut_counts/rm_inter2_cKWIA.txt $basedir/derived_mutations/cKIWA_der_intergenic2.temp | cut -f 1-7 >> $basedir/derived_mutations/cKIWA_der_intergenic2.maf
```

## Modify hKIWA Files
```bash
mutations="deleterious tolerated lossoffunction noncoding nonsynonymous synonymous intergenic1 intergenic2"

for i in $(echo $mutations); do
    cut -f 1-7 $basedir/derived_mutations/hKIWA_der_${i}.temp >> $basedir/derived_mutations/hKIWA_der_${i}.maf;
done

```

## Add Headers 
```bash
mutations="deleterious tolerated lossoffunction noncoding nonsynonymous synonymous intergenic1 intergenic2"

for i in $(echo $mutations); do
    zcat $basedir/mafs/cKIWA.mafs.gz | head -1 >> $basedir/hKIWA_der_${i}.maf
    cat $basedir/derived_mutations/hKIWA_der_${i}.maf >> $basedir/hKIWA_der_${i}.maf;
done

for i in $(echo $mutations); do
    zcat $basedir/mafs/cKIWA.mafs.gz | head -1 >> $basedir/cKIWA_der_${i}.maf
    cat $basedir/derived_mutations/cKIWA_der_${i}.maf >> $basedir/cKIWA_der_${i}.maf;
done

for i in $(echo $mutations); do
    wc -l *KIWA_der_${i}.maf;
done
```

## Create Summary 
```bash
#DEL
cat summary_header.txt >> der_del.txt
paste cKIWA_der_deleterious.maf hKIWA_der_deleterious.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_del.txt

#INTER1
cat summary_header.txt >> der_inter1.txt
paste cKIWA_der_intergenic1.maf hKIWA_der_intergenic1.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_inter1.txt

#INTER2
cat summary_header.txt >> der_inter2.txt
paste cKIWA_der_intergenic2.maf hKIWA_der_intergenic2.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_inter2.txt

#LOF
cat summary_header.txt >> der_lof.txt
paste cKIWA_der_lossoffunction.maf hKIWA_der_lossoffunction.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_lof.txt

#NONCODE
cat summary_header.txt >> der_noncode.txt
paste cKIWA_der_noncoding.maf hKIWA_der_noncoding.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_noncode.txt

#NONSYN
cat summary_header.txt >> der_nonsyn.txt
paste cKIWA_der_nonsynonymous.maf hKIWA_der_nonsynonymous.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_nonsyn.txt

#SYN
cat summary_header.txt >> der_syn.txt
paste cKIWA_der_synonymous.maf hKIWA_der_synonymous.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_syn.txt

#TOL
cat summary_header.txt >> der_tol.txt
paste cKIWA_der_tolerated.maf hKIWA_der_tolerated.maf | awk '$7>=3 && $14>=3 {print $0}' | cut -f 1-4,6,7,13,14 | sed 1d >> der_tol.txt

```
rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/*KIWA_der_lossoffunction.maf /Users/annamariacalderon/Desktop


rsync abc6435@submit.hpc.psu.edu:/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy/*KIWA_der_intergenic1.maf /Users/annamariacalderon/Desktop
