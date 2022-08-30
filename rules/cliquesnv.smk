shell.prefix("set -eo pipefail; ")


rule cliquesnv:
  input:
    "data/{sample}/{sample}.bt2.rmdup.bam"
  output:
    "data/{sample}/{sample}.haplotypes.cliquesnv.fasta"
  params:
    cliquesnv=config["params"]["cliquesnv"]
  log:
    "data/{sample}/logs/cliquesnv.log"
  threads: config["threads"]["cliquesnv"]
  conda:
    "../envs/cliquesnv.yaml"


  shell:
      """
      bamtools split -in {input} -reference

      for i in data/{wildcards.sample}/*REF*.bam;
      do
      cliquesnv -m snv-illumina \
                -threads {threads} \
                -in $i \
                -fdf extended \
                -outDir data/{wildcards.sample}/cliquesnv_out \
                {params.cliquesnv} \
                >> {log} 2>&1
      done

      cat data/{wildcards.sample}/cliquesnv_out/{wildcards.sample}.bt2*.fasta > {output}
      rm data/{wildcards.sample}/cliquesnv_out/{wildcards.sample}.bt2*.fasta
      """
