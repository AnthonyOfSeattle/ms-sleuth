import os
import pandas as pd

def get_sample_table():
    """Load sample table from config"""

    sample_df = pd.read_table(config["input"])
    sample_df["sample_name"] = [os.path.splitext(f)[0] for f in sample_df.file]

    return sample_df

def get_final_output():
    """Currently returns major mokapot files in their target directory"""

    outputs = [os.path.join(config["output"], "score", "mokapot.psms.txt"),
               os.path.join(config["output"], "score", "mokapot.peptides.txt"),
               os.path.join(config["output"], "score", "mokapot.proteins.txt")]

    return outputs
