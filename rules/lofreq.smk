shell.prefix("set -eo pipefail; ")


rule lofreq:
  input:
    "data/{sample}/{sample}.consensus.fa"
  output:
    "data/{sample}/{sample}.lofreq.vcf"
  log:
    "data/{sample}/logs/lofreq.log"
  conda:
    "../envs/lofreq.yaml"
  shell:
      """
      mkdir data/{wildcards.sample}/lofreq || true

      samtools view \
            -b \
            -T {input} \
            data/{wildcards.sample}/{wildcards.sample}.bt2.rmdup.bam \
        | lofreq viterbi \
            -f {input} \
            - \
        | samtools sort \
            - \
        | lofreq indelqual \
            -f {input} \
            --dindel \
            - \
        > data/{wildcards.sample}/lofreq/{wildcards.sample}.lofreq.bam

        lofreq alnqual \
            -b \
            data/{wildcards.sample}/lofreq/{wildcards.sample}.lofreq.bam \
            {input} \
        > data/{wildcards.sample}/lofreq/{wildcards.sample}.lofreq.qual.bam

        samtools index data/{wildcards.sample}/lofreq/{wildcards.sample}.lofreq.qual.bam

        lofreq call \
            -f {input} \
            -o {output} \
            data/{wildcards.sample}/lofreq/{wildcards.sample}.lofreq.qual.bam
      """
