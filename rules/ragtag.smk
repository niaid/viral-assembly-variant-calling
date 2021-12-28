shell.prefix("set -eo pipefail; ")


rule ragtag:
  input:
    "data/{sample}/spades/contigs.fasta"
  output:
    "data/{sample}/ragtag/ragtag.scaffold.fasta"
  threads: config["threads"]["ragtag"]
  params: config["params"]["ref"]
  log:
    "data/{sample}/logs/ragtag.log"
  conda:
    "../envs/ragtag.yaml"

  shell:
      """
      ragtag.py correct \
                -f 100 \
                -b 100 \
                -o data/{wildcards.sample}/ragtag \
                -t {threads} \
                {params} \
                {input} > {log} 2>&1

      ragtag.py scaffold \
                -C \
                -f 100 \
                -r \
                -g 10 \
                -o data/{wildcards.sample}/ragtag \
                -t {threads} \
                {params} \
                data/{wildcards.sample}/ragtag/ragtag.correct.fasta > {log} 2>&1
      """

rule clean_ragtag:
    input:
        "data/{sample}/ragtag/ragtag.scaffold.fasta"
    output:
        "data/{sample}/ragtag/ragtag.scaffold.clean.fasta"
    log:
        "data/{sample}/logs/ragtag.log"
    conda:
        "../envs/ragtag.yaml"
    script:
        "../scripts/clean_ragtag.py"
