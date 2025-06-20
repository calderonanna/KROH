# Calculate Rxy

- Pop A = historica KIWA
- Pop B = contemporary KIWA

- Rxy > 1: enrichment of derived alleles in pop A
- Rxy = 1: no difference
- Rxy < 1: purging of derived alleles in pop A

```bash
#Set Variables
rxy="/storage/home/abc6435/SzpiechLab/bin/Rxy-kin"
work_dir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/data/rxy"
vcf="KIWA_tags_auto_bi_private_nmiss.vcf.gz"

$rxy/Rxy-kin.py \
    -v $work_dir/$vcf \
    -1 $work_dir/del.txt \
    -2 $work_dir/inter1.txt \
    -A $work_dir/pop_A.txt \
    -B $work_dir/pop_B.txt

```
## Rxy Result
```bash
#DEL
echo "0.3275034197717955 0.31936912907479054 0.3364372842698914 DEL INTER1" >> rxy_results.txt
echo "0.3068304670835901 0.29664367001376485 0.3167021466345562 DEL INTER2" >> rxy_results.txt

#LOF
echo "0.39013362818799946 0.34331058056915403 0.4362393521845782 LOF INTER1" >> rxy_results.txt
echo "0.36550727758919255 0.3198172136801738 0.3958012200957418 LOF INTER2" >> rxy_results.txt

#NONCODE
echo "0.3376841394172492 0.32858332802257456 0.34500371993187445 NONCODE INTER1" >> rxy_results.txt
echo "0.31636855058280433 0.3100820102193361 0.32400339974176684 NONCODE INTER2" >> rxy_results.txt

#SYN
echo "0.38117848096053925 0.3735889960020575 0.3881172571858448 SYN INTER1" >> rxy_results.txt
echo "0.35711740487116556 0.3496270333621281 0.3668109597573758 SYN INTER2" >> rxy_results.txt

#NONSYN
echo "0.3363030596193362 0.328710008641931 0.3437251418705222 NONSYN INTER1" >> rxy_results.txt
echo "0.315074648492351 0.3075899874906213 0.32279432626136667 NONSYN INTER2" >> rxy_results.txt

#TOL
echo "0.36936785321669713 0.3627152872596284 0.3779934575682507 TOL INTER1" >> rxy_results.txt
echo "0.34605229773512836 0.337091348893974 0.3533261510547629 TOL INTER2" >> rxy_results.txt
```
## Rxy Results (Downsampled)
```bash
#DEL
echo "0.29333532125238676 0.28272460807519206 0.3020125271410163 DEL INTER1" >> rxy_results_downsampled.txt
echo "0.3217177260940577 0.3101050575575494 0.33178197625509204 DEL INTER2" >> rxy_results_downsampled.txt

#LOF
echo "0.34943138375662713 0.3156015324295383 0.3799243625554586 LOF INTER1" >> rxy_results_downsampled.txt
echo "0.38324150575565036 0.3385249079925874 0.4220402612891551 LOF INTER2" >> rxy_results_downsampled.txt

#NONCODE
echo "0.30245389677706536 0.29613916656117667 0.3092600366536683 NONCODE INTER1" >> rxy_results_downsampled.txt
echo "0.3317185925785014 0.324070441182216 0.3413879632009352 NONCODE INTER2" >> rxy_results_downsampled.txt

#SYN
echo "0.3414105179267074 0.33455507998347594 0.3491101787078381 SYN INTER1" >> rxy_results_downsampled.txt
echo "0.3744445606585168 0.3655776923430891 0.38347187794357207 SYN INTER2" >> rxy_results_downsampled.txt

#NONSYN
echo "0.3012169036290907 0.29337028707002166 0.307893237954626 NONSYN INTER1" >> rxy_results_downsampled.txt
echo "0.3303619110133178 0.32299105213608886 0.34024298204175857 NONSYN INTER2" >> rxy_results_downsampled.txt

#TOL
echo "0.33083208095696126 0.32240810916707074 0.3369080384718338 TOL INTER1" >> rxy_results_downsampled.txt
echo "0.36284258012304665 0.3562603709797988 0.37061995536423065 TOL INTER2" >> rxy_results_downsampled.txt
```