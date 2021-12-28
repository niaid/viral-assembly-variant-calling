from Bio import SeqIO

with (
    open(snakemake.input[0], 'r', encoding='utf-8') as infile,
    open(snakemake.output[0], 'w', encoding='utf-8') as outfile
    ):
    for record in SeqIO.parse(infile, 'fasta'):
        if record.id != "Chr0_RagTag":
            record.id = record.id.strip('_RagTag')
            SeqIO.write(record, outfile,'fasta')
