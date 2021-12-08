## Automated mass spectrometry database search and scoring

The most ubiquitous analyis step for DDA mass spectrometry data is database search.
This module is focused completely on that step, with hopes to simplify the process.
In the end, I hope that this module will accomplish three tasks:

 - Parallelized database search with Comet
 - Efficient PSM, peptide, and Protein scoring with mokapot
 - PTM localization scoring with PyAscore
