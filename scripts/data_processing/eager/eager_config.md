# Configuration File
Defines job parameters for the different bioinfo programs, specifies working directory, executor, resource allocations etc. 

```bash
KROH_folder="/storage/home/abc6435/SzpiechLab/abc6435/KROH"

nano $KROH_folder/eager_src/eager_config_R_KIWA_NextSeq2000_WGS.sh
#--------------NANO--------------
workDir = "/storage/home/abc6435/SzpiechLab/abc6435/KROH"

params {
  config_profile_description = 'Penn State roar-collab cluster profile provided by nf-core/configs'
  config_profile_contact = 'Anna Maria Calderon (@abc64350, @apeltzer)'
  config_profile_url = 'www.mpw.com'
  max_memory = 128.GB
  max_cpus = 24
  max_time = 48.h
}

singularity {
  enabled = true
  autoMounts = true
  cacheDir="/storage/home/abc6435/SzpiechLab/abc6435/KROH/software.tmp_nxf"
}

process {
    executor = 'slurm'
    clusterOptions = "-N 1 --account=zps5164_sc  --partition=burst --qos=burst4x"
    publishDir = "/storage/home/abc6435/SzpiechLab/abc6435/KROH/software/results"


 withName:'bwa'{
       cpus = { 16 * task.attempt }
       memory = { 32.GB * task.attempt }
       time = { 96.h * task.attempt }
  }
  withName:'markduplicates'{
        cpus = { 8 * task.attempt }
        memory = { 16.GB * task.attempt }
        time = { 8.h * task.attempt }
   }
   withName:'dedup'{
         cpus = { 8 * task.attempt }
         memory = { 16.GB * task.attempt }
         time = { 24.h * task.attempt }
   }
   withName: 'preseq' {
         cpus = { 24 * task.attempt }
         memory = { 8.GB * task.attempt }
         time = { 48.h * task.attempt }
   }
   withName:'genotyping_angsd'{
         cpus = { 8 * task.attempt }
         memory = { 8.GB * task.attempt }
         time = { 24.h * task.attempt }
   }
   withName:'damageprofiler' {
         cpus = { 8 * task.attempt }
         memory = { 64.GB * task.attempt }
         time = { 24.h * task.attempt }
   }
   withName: 'get_software_versions' {
         cpus = { 4 * task.attempt }
         memory = { 4.GB * task.attempt }
         time = { 12.h * task.attempt }
   }
   withName: 'bedtools' {
         cpus = { 16 * task.attempt }
         memory = { 24.GB * task.attempt }
         time = { 12.h * task.attempt }
   }
   withName: 'pmdtools' {
         cpus = { 8 * task.attempt }
         memory = { 16.GB * task.attempt }
         time = { 48.h * task.attempt }
         errorStrategy = 'ignore'
   }
}

#--------------EOS--------------
```