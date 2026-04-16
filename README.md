**Gene Ortholog Conversion Pipeline (Mouse ↔ Human)**
===================================================

**Author:** Oliver Abinader


**Overview**
This repository provides a simple and reproducible pipeline to convert gene identifiers between species using the R package orthogene.
It is primarily designed for:
	•	Differential expression (DE) datasets
	•	Cross-species comparisons (e.g., mouse → human)
	•	Downstream pathway analysis and integration ////delete
The workflow maps genes from one species to orthologs in another while preserving the original dataset structure.

**Features**
	•	Converts gene identifiers using g:Profiler-based orthology mapping
	•	Supports flexible input/output species selection
	•	Handles genes without orthologs (keeps or filters based on user preference)
	•	Merges ortholog annotations back into original DE tables
	•	Generates summary statistics on mapping efficiency
	•	Outputs a clean, ready-to-use CSV file

**Dependencies**
This pipeline requires the following R packages:
- BiocManager
- orthogene
- readr
- writexl

Install missing packages using:

install.packages("BiocManager")
BiocManager::install("orthogene")
install.packages("readr")
install.packages("writexl")

**Input Format**
The input file should be a CSV file containing differential expression results.
Required column:
	•	ID → Gene identifiers (preferably Ensembl IDs)

**Workflow Description**
1. Load input data
Reads DE results.

2. Define species mapping
Set source and target species:
input_species <- "mouse"
output_species <- "human"

3. Ortholog conversion
Uses orthogene::convert_orthologs() to map genes across species.
Key settings:
	•	Method: gprofiler
	•	Keeps genes without orthologs (optional)
	•	Supports one-to-many mappings

4. Merge results
Orthologs are merged back into the original DE table.

5. Summary statistics
Reports:
	•	Number of genes with orthologs
	•	Number of unique orthologs
	•	Missing mappings (NA, "N/A")

6. Output generation
Writes final dataset to: Differential_expression_analysis_table.ortholog.csv

**Output Description**
The final output file contains:
	•	Original DE table columns
	•	ortholog_gene → mapped gene symbol in target species

**Example Usage**
Run the script in R: source("ortholog_conversion.R")

Or execute step-by-step within an R session.

**Typical Use Cases**
	•	Mouse → Human translational analysis
	•	Cross-species RNA-seq comparison
