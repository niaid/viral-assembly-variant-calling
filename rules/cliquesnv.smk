shell.prefix("set -eo pipefail; ")


rule cliquesnv:
  input:
    "data/{sample}/{sample}.bt2.rmdup.bam"
  output:
    "data/{sample}/{sample}.haplotypes.cliquesnv.fasta"
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
                > {log} 2>&1
      mv data/{wildcards.sample}/cliquesnv_out/*.fasta data/{wildcards.sample}/
      rm -rf data/{wildcards.sample}/cliquesnv_out/cliquesnv_out
      done

      cat data/{wildcards.sample}/{wildcards.sample}.bt2*.fasta > {output}
      """
