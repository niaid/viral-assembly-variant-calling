shell.prefix("set -eo pipefail; ")

def myref(param):
    if param == "denovo":
        return "data/{sample}/ragtag/ragtag.scaffold.clean.fasta"
    elif param == "mapping":
        return config["params"]["ref"]
