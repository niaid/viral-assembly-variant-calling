shell.prefix("set -eo pipefail; ")


rule trinity:
  input:
    in1="data/{sample}/ec/{sample}_R1.clean.ec.fastq.gz",
    in2="data/{sample}/ec/{sample}_R2.clean.ec.fastq.gz"
  output:
    out1="data/{sample}/trinity/{sample}.trinity.Trinity.fasta",
  threads: config["threads"]["trinity"]
  params: config["params"]["trinity"]
  log:
    "data/{sample}/logs/trinity.log"
  conda:
    "../envs/trinity.yaml"

  shell:
      """
      Trinity --seqType fq \
              --left {input.in1} \
              --right {input.in2} --full_cleanup \
              --output data/{wildcards.sample}/trinity/{wildcards.sample}.trinity \
              --CPU {threads} \
              {params} > {log} 2>&1
      """
