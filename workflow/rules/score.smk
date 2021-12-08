def get_mokapot_input():
    """Expand input sample names to attatch all comet output to mokapot step""" 

    samples = get_sample_table()
    files = expand(os.path.join(config["output"],
                                "search",
                                "{dataset}",
                                "{sample_name}.pin"),
                   zip, **samples,
                   )

    return files

rule mokapot:
    input:
        spectra = get_mokapot_input(),
        database = os.path.join(config["output"], "search", "combined.fasta")
    output:
        psms = os.path.join(config["output"], "score", "mokapot.psms.txt"),
        peptides = os.path.join(config["output"], "score", "mokapot.peptides.txt"),
        proteins = os.path.join(config["output"], "score", "mokapot.proteins.txt")
    conda:
        "../envs/score.yaml"
    params:
        destination = os.path.join(config["output"], "score"),
        decoy_prefix = config["mokapot"]["decoy_prefix"],
        enzyme = config["mokapot"]["enzyme"],
        missed_cleavages = config["mokapot"]["missed_cleavages"],
        min_length = config["mokapot"]["min_length"],
        max_length = config["mokapot"]["max_length"],
        seed = config["mokapot"]["seed"] 
    shell:
        """
        mokapot --dest_dir {params.destination} \
                --proteins {input.database} \
                --decoy_prefix {params.decoy_prefix} \
                --enzyme {params.enzyme} \
                --missed_cleavages {params.missed_cleavages} \
                --min_length {params.min_length} \
                --max_length {params.max_length} \
                --seed {params.seed} \
                --keep_decoys \
                --aggregate \
                {input.spectra}
        """
