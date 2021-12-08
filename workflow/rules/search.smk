rule combine_databases:
    input:
        config["database"]["location"]
    output:
       os.path.join(config["output"], "search", "combined.fasta")
    shell:
        """
        cat {input} > {output}
        """

rule write_comet_params:
    input:
        os.path.join(config["output"], "search", "combined.fasta")
    output:
        os.path.join(config["output"], "search", "comet.params")
    run:
        automatic_fields = ["database_name = {}".format(input),
                            "decoy_search = 1",
                            "output_pepxmlfile = 0",
                            "output_mzidentmlfile = 1",
                            "output_percolatorfile = 1"]

        controlled_fields = []
        for k,v in config["comet"].items():
            if k != "enzyme_info":
              controlled_fields.append("{} = {}".format(k, v))

        enzyme_fields = config["comet"]["enzyme_info"]

        with open(output[0], "w") as dest:
          dest.write("# comet_version 2021.01 rev. 0" + "\n")

          dest.write("\n" + "# ms-sleuth generated fields" + "\n")
          dest.writelines([f + "\n" for f in automatic_fields])

          dest.write("\n" + "# fields from config file" + "\n")
          dest.writelines([f + "\n" for f in controlled_fields])

          dest.write("\n" + "[COMET_ENZYME_INFO]" + "\n")
          dest.writelines([f + "\n" for f in enzyme_fields])


def get_comet_input(wildcards):
    """Get relative or absolute location of input"""

    samples = get_sample_table()
    record = samples.set_index(["dataset", "sample_name"]).T[wildcards.dataset][wildcards.sample_name]
    return os.path.join(record.location, record.file)

rule comet:
    input:
        spectra = get_comet_input,
        params = os.path.join(config["output"], "search", "comet.params")
    output:
        mzid = os.path.join(config["output"],
                            "search",
                            "{dataset}",
                            "{sample_name}.mzid"),
        pin = os.path.join(config["output"],
                           "search",
                           "{dataset}",
                           "{sample_name}.pin")
    conda:
        "../envs/search.yaml"
    shadow:
        "shallow"
    shell:
        """
        cp {input.spectra} {input.params} ./
        comet -Pcomet.params $(basename {input.spectra})
        cp *.mzid {output.mzid}; cp *.pin {output.pin}
        """
