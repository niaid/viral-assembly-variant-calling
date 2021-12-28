shell.prefix("set -eo pipefail; ")

rule bbduk:
  input:
  output:
    out1="data/{sample}/clean/{sample}_R1.clean.fastq",
    out2="data/{sample}/clean/{sample}_R2.clean.fastq"
  log:
        "data/{sample}/logs/trim.log"
  params:
        adapters=config["params"]["adapters"],
        bbduk=config["params"]["bbduk"],
        primers=config["params"]["primers"]
  threads: config["threads"]["bbduk"]
  conda:
        "../envs/bbduk.yaml"
  shell:
      """
      rm data/{wildcards.sample}/fastq/*.cat.fastq 2>/dev/null || true
      gunzip data/{wildcards.sample}/fastq/*.fastq.gz 2>/dev/null || true
      cat data/{wildcards.sample}/fastq/*1.fastq* > data/{wildcards.sample}/fastq/{wildcards.sample}_1.cat.fastq
      cat data/{wildcards.sample}/fastq/*2.fastq* > data/{wildcards.sample}/fastq/{wildcards.sample}_2.cat.fastq

      if [ -z {params.primers} ]
      then
      # trim adapters and quality trim
      bbduk.sh \
        threads={threads} \
        -Xmx100g \
        in=data/{wildcards.sample}/fastq/{wildcards.sample}_1.cat.fastq \
        in2=data/{wildcards.sample}/fastq/{wildcards.sample}_2.cat.fastq \
        out={output.out1} \
        out2={output.out2} \
        ref={params.adapters} \
        {params.bbduk} \
        > {log} 2>&1

      else
      bbduk.sh \
        threads={threads} \
        -Xmx100g \
        in=data/{wildcards.sample}/fastq/{wildcards.sample}_1.cat.fastq \
        in2=data/{wildcards.sample}/fastq/{wildcards.sample}_2.cat.fastq \
        out=data/{wildcards.sample}/clean/adapter_cleaned_R1.tmp.fastq \
        out2=data/{wildcards.sample}/clean/adapter_cleaned_R2.tmp.fastq \
        ref={params.adapters} \
        {params.bbduk} \
        > {log} 2>&1

      #trim primer sequences
      bbduk.sh \
         in=data/{wildcards.sample}/clean/adapter_cleaned_R1.tmp.fastq \
         in2=data/{wildcards.sample}/clean/adapter_cleaned_R2.tmp.fastq \
         out={output.out1} \
         out2={output.out2} \
         ref={params.primers} \
         ktrim=l restrictleft=30 k=22 hdist=3 qhdist=1 rcomp=f mm=f >> {log} 2>&1
      fi

      """
