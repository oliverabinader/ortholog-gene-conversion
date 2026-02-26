# Example: Mouse → Human ortholog conversion using orthogene
# Author: Oliver Abinader
# Date: 02-25-2026

# ---- One-time installs (uncomment if needed) ----
# install.packages("BiocManager")
# BiocManager::install(version = "3.14")
# BiocManager::install("orthogene")
# install.packages("readr")
# install.packages("writexl")

# ---- Load libraries ----
library(orthogene)
library(readr)
library(writexl)

# ---- USER SETTINGS ----
# Modify species depending on the project
input_species <- "mouse"
output_species <- "human"

# ---- Input ----
# Place your DE table in the data/ folder of this repo
infile <- "data/Differential_expression_analysis_table.csv"
DE_analysis_table <- readr::read_csv(infile, show_col_types = FALSE)

# Expect gene identifiers (to be Ensembl IDs) and DE columns
data <- as.data.frame(DE_analysis_table)

# ---- Convert orthologs ----
converted_data <- orthogene::convert_orthologs(
  gene_df = data,
  gene_input = "ID",                 # if using Ensembl IDs (not symbols), use "ID"
  gene_output = "columns",           # this value should not be changed
  input_species = input_species,     # reference genome/species the input IDs come from
  output_species = output_species,   # ortholog target species
  drop_nonorths = FALSE,             # keep genes even without orthologs
  non121_strategy = "keep_both_species",
  method = "gprofiler"
)

# ---- Merge orthologs back into DE dataset ----
data_with_orthologs <- merge(
  data,
  converted_data[, c("input_gene", "ortholog_gene")],
  by.x = "ID",
  by.y = "input_gene",
  all.x = TRUE
)

# ---- Data summary ----
genes_with_orthologs <- sum(!is.na(data_with_orthologs$ortholog_gene) & data_with_orthologs$ortholog_gene != "N/A")

unique_orthologs <- length(unique(data_with_orthologs$ortholog_gene[!is.na(data_with_orthologs$ortholog_gene) &
      data_with_orthologs$ortholog_gene != "N/A"]))

na_orthologs <- sum(is.na(data_with_orthologs$ortholog_gene))

na_string_orthologs <- sum(data_with_orthologs$ortholog_gene == "N/A", na.rm = TRUE)

# ---- Output ----
if (!dir.exists("out")) dir.create("out/", recursive = TRUE)
outfile <- "out/Differential_expression_analysis_table.ortholog.csv"
readr::write_csv(data_with_orthologs, outfile)
