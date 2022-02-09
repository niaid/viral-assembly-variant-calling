# Viral genome assembly and variant calling

This is a Snakemake pipeline to generate a consensus sequence and call variants (SNPs and haplotypes) using viral amplicon short-read Illumina data and a reference genome. Much of the work is performed by the Python script [ConsIter.py](https://github.com/TheDBStern/ConsIter) which iterates mapping of reads to a reference genome, calling variants, and updating the reference genome until there is no improvement in mapping rate. It then masks bases below a specified coverage threshold.

Download this repository with
`git clone --recursive https://github.com/niaid/viral-assembly-variant-calling`


There are two pipeline options:
1. Reference-mapping approach. Map error-corrected reads to a reference genome and generate a consensus sequence based on majority variants. Best if the data are expected to be quite similar to the reference genome.
2. De-novo assembly and scaffolding. Assemble contigs directly from error-corrected reads. Scaffold the contigs (i.e. order and orient) based on alignment to a reference genome. Best if the data are expected to be quite divergent from the reference genome and may have large structural variants.

The `ref` directory should contain adapter sequences and the reference genome. If targeted amplicon sequencing was performed, a multifasta file with each targeted region can be provided.

The data directory should have a separate directory for each sample. Multiple fastq files per sample will be concatenated prior to analysis. **All fastq files should end with either _R1.fastq or _R2.fastq. Only paired-end (PE) reads are supported**.

An example directory structure is below:

```bash
data
├── SRR8209080
│   └── fastq
│       ├── SRR8209080_R1.fastq
│       └── SRR8209080_R2.fastq
├── SRR8209081
│   └── fastq
│       ├── SRR8209081_R1.run1.fastq
│       └── SRR8209081_R2.run1.fastq
|       ├── SRR8209081_R1.run2.fastq
│       └── SRR8209081_R2.run2.fastq
└── SRR8209083
    └── fastq
        ├── SRR8209083_R1.fastq
        └── SRR8209083_R2.fastq
```

### Usage:  

Edit the `config.yaml` file to indicate whether you want to run the reference-mapping- or denovo-assembly-based approach, and the names of files with the reference genome, adapter sequences, and (optionally) primer sequences. Those files should be placed in the `ref` directory.  
Edit the `samples.csv` file with the names of the samples in the `data` directory, structured as shown above.

Run: `snakemake --cores <ncores> --use-conda all` with <ncores> replaced with your desired number of CPU cores.  

### Dependencies  
Running this pipeline requires:
- [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)  
- [Conda](https://docs.conda.io/en/latest/)  

All other required bioinformatic tools will be installed in isolated conda environments automatically using Snakemake when the pipeline is run:
- [BBTools](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/)  
- [Bowtie2 v2.4.4](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)  
- [GATK v4.2.2](https://gatk.broadinstitute.org/hc/en-us/articles/360036194592-Getting-started-with-GATK4)  
- [Picard v2.26](https://broadinstitute.github.io/picard/)  
- [Samtools v1.13](http://www.htslib.org/)  
- [BedTools v2.30](https://bedtools.readthedocs.io/en/latest/)  
- [RagTag v2.0.1](https://github.com/malonge/RagTag)  
- [Minimap2](https://github.com/lh3/minimap2)  
- [Biopython v1.79](https://biopython.org/)  
- [Spades v3.15.3](https://github.com/ablab/spades)  
- [LoFreq v2.1.5](https://csb5.github.io/lofreq/)  
- [CliqueSNV v2.0.2](https://github.com/vtsyvina/CliqueSNV)  
- [Bamtools v2.4.0](https://bioinformatics.readthedocs.io/en/latest/bamtools/)  

### Output files:
Output files are in each sample directory under `data`.  
`*.consensus.fa` -- final consensus sequences for all sequences in reference fasta file   
`*.consensus.sample_name.fa` -- same as above but sample name included in fasta headers  
`*.bt2.rmdup.bam` -- input reads aligned to consensus sequences using bowtie2, duplicates removed  
`*.haplotypes.cliquesnv.fasta` -- haplotypes (and frequencies) for all references sequences reconstructed using cliqueSNV  
    `*REF*.fasta` -- haplotypes reconstructed for each reference sequence in the reference fasta file  
`*.lofreq.vcf` -- within-sample variants (iSNVs) with frequencies determined using LoFreq

### Terms of Use

By using this software, you agree this software is to be used for research purposes only. Any presentation of data analysis using the software will acknowledge the software according to the guidelines below.

Primary author(s): David B. Stern

Organizational contact information: david.stern AT nih.gov

Date of release: 12/28/2021

Version: 0.1

License details: see LICENSE file


### Disclaimer

A review of this code has been conducted, no critical errors exist, and to the best of the authors knowledge, there are no problematic file paths, no local system configuration details, and no passwords or keys included in this code. This open source software comes as is with absolutely no warranty.
