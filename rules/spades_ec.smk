shell.prefix("set -eo pipefail; ")


rule spades_ec:
  input:
    in1="data/{sample}/clean/{sample}_R1.clean.fastq",
    in2="data/{sample}/clean/{sample}_R2.clean.fastq"
  output:
    out1="data/{sample}/ec/{sample}_R1.clean.ec.fastq.gz",
    out2="data/{sample}/ec/{sample}_R2.clean.ec.fastq.gz"
  threads: config["threads"]["spades_ec"]
  log:
    "data/{sample}/logs/spades_ec.log"
  conda:
    "../envs/spades.yaml"

  shell:
      """
      spades.py --only-error-correction \
          -t {threads} \
          -1 {input.in1} \
          -2 {input.in2} \
          -o data/{wildcards.sample}/ec > {log} 2>&1

      mv data/{wildcards.sample}/ec/corrected/{wildcards.sample}_R1.clean.00.0_0.cor.fastq.gz {output.out1}
      mv data/{wildcards.sample}/ec/corrected/{wildcards.sample}_R2.clean.00.0_0.cor.fastq.gz {output.out2}
      rm -rf data/{wildcards.sample}/ec/corrected
      """
