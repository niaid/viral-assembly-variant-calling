shell.prefix("set -eo pipefail; ")


rule spades_assemble:
  input:
    in1="data/{sample}/ec/{sample}_R1.clean.ec.fastq.gz",
    in2="data/{sample}/ec/{sample}_R2.clean.ec.fastq.gz"
  output:
    out1="data/{sample}/spades/contigs.fasta",
  threads: config["threads"]["spades_assemble"]
  log:
    "data/{sample}/logs/spades_assemble.log"
  conda:
    "../envs/spades.yaml"

  shell:
      """
      spades.py --meta -o data/{wildcards.sample}/spades/ \
      -1 {input.in1} \
      -2 {input.in2} \
      --only-assembler \
      > {log} 2>&1
      """
