shell.prefix("set -eo pipefail; ")

include: "common.smk"

rule consiter:
  input:
    in1="data/{sample}/ec/{sample}_R1.clean.ec.fastq.gz",
    in2="data/{sample}/ec/{sample}_R2.clean.ec.fastq.gz",
    ref=myref(config["pipeline"])
  output:
    out1="data/{sample}/{sample}.consensus.fa",
    out2="data/{sample}/{sample}.bt2.rmdup.bam"
  params:
    srcdir=workflow.basedir,
    consiter=config["params"]["consiter"]
  threads: config["threads"]["consiter"]
  conda:
    "../envs/consiter.yaml"
  log:
    "data/{sample}/logs/consiter.log"

  shell:
      """
      export PYTHONUNBUFFERED=True
      mkdir -p data/{wildcards.sample}/ref
      cp {input.ref} data/{wildcards.sample}/ref/
      sampleref="data/{wildcards.sample}/ref/$(basename {input.ref})"

      python {params.srcdir}/ConsIter/ConsIter.py \
              -ref ${{sampleref}} \
              -t {threads} \
              -n {wildcards.sample} \
              -o data/{wildcards.sample} \
              -1 {input.in1} \
              -2 {input.in2} \
              {params.consiter} \
              > {log} 2>&1
      """
