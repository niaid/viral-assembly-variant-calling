import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.1.2")


##### load config and sample sheets #####

configfile: "config.yaml"

samples = pd.read_csv(config["samples"])
samples.set_index("sample", drop=False, inplace=True)

##### target rules #####
rule all:
  input:
    expand("data/{sample}/{sample}.lofreq.vcf", sample=samples.index),
    expand("data/{sample}/{sample}.haplotypes.cliquesnv.fasta", sample=samples.index)

##### load rules #####

include: "rules/bbduk.smk"
include: "rules/spades_ec.smk"
include: "rules/consiter.smk"
include: "rules/lofreq.smk"
include: "rules/cliquesnv.smk"
include: "rules/spades_assemble.smk"
include: "rules/ragtag.smk"
