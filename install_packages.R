# Setup ----

target_lib <- "~/R-obds"
bioc_version <- "3.17"

file_out <- file("packages.out", open = "wt")
file_err <- file("packages.err", open = "wt")

sink(file = file_out, type = "output")
sink(file = file_err, type = "message")

# Start ----

start_time <- Sys.time()
dir.create(target_lib, showWarnings = FALSE)
.libPaths(target_lib)

# Please list packages alphabetically within each command, for each of search by other contributors.

## BiocManager ----

install.packages("BiocManager", lib = target_lib)
BiocManager::install(version = bioc_version, lib = target_lib)

## CRAN ----

cran_packages <- c(
  "cowplot",
  "dbscan",
  "dendextend",
  "dplyr",
  "ggplot2",
  "ggrepel",
  "googledrive",
  "gprofiler2",
  "gridExtra",
  # "harmony", # TODO: removed from CRAN on 30-10-2022, uncomment when fixed
  "markdown",
  "patchwork",
  "pheatmap",
  "readr",
  "readxl",
  "remotes",
  "RColorBrewer",
  "Rtsne",
  "R.utils",
  "sctransform",
  "Seurat",
  "sessioninfo",
  "tidyverse",
  "umap",
  "WGCNA"
)

## Bioconductor ----

bioconductor_packages <- c(
  "apeglm",
  "ashr",
  "batchelor",
  "BiocStyle",
  "biomaRt",
  "Biostrings",
  "BSgenome",
  "BSgenome.Hsapiens.UCSC.hg38.masked",
  "celda",
  "clusterProfiler",
  "DESeq2",
  "DropletUtils",
  "drosophila2probe",
  "EnsDb.Hsapiens.v86",
  "ExperimentHub",
  "fgsea",
  "impute",
  "iSEE",
  "genefilter",
  "limma",
  "MAST",
  "org.Hs.eg.db",
  "org.Mm.eg.db",
  "preprocessCore",
  "ReactomePA",
  "rgl",
  "rtracklayer",
  "scater",
  "scDblFinder",
  "scRNAseq",
  "scuttle",
  "SingleCellExperiment",
  "SummarizedExperiment",
  "sva",
  "TxDb.Hsapiens.UCSC.hg38.knownGene",
  "tximeta",
  "tximportData"
)

## GitHub ----

github_repositories <- c(
  "chris-mcginnis-ucsf/DoubletFinder",
  "immunogenomics/harmony",
  "immunogenomics/lisi",
  "satijalab/seurat-data",
  "satijalab/seurat-wrappers"
)

## Installation ----

BiocManager::install(
  c(
    cran_packages,
    bioconductor_packages,
    github_repositories),
  version = bioc_version,
  ask = FALSE,
  update = TRUE,
  Ncpu=4L,
  lib = target_lib
)

## Post-installation checks ----

### Validate installed package versions against correct versions.

BiocManager::valid()

### Check that all requested CRAN packages are installed

if (!all(cran_packages %in% rownames(installed.packages()))) {
  setdiff(cran_packages, rownames(installed.packages()))
} else {
  message("All CRAN packages installed successfully")
}

### Check that all requested Bioconductor packages are installed

if (!all(bioconductor_packages %in% rownames(installed.packages()))) {
  setdiff(bioconductor_packages, rownames(installed.packages()))
} else {
  message("All Bioconductor packages installed successfully")
}

### Check that all requested packages from GitHub repositories are installed

github2name <- function(repo) {
  con <- url(sprintf("https://raw.githubusercontent.com/%s/master/DESCRIPTION", repo))
  y <- read.dcf(file = con)
  close(con)
  y[1, "Package", drop = TRUE]
}
github_packages <- vapply(github_repositories, github2name, NA_character_)

if (!all(github_packages %in% rownames(installed.packages()))) {
  github_packages[!github_packages %in% rownames(installed.packages())]
} else {
  message("All GitHub packages installed successfully")
}

# Cleanup ----

end_time <- Sys.time()

message(sprintf("Script completed in %.2f seconds", as.numeric(end_time - start_time)))


sink(file = NULL, type = "output")
sink(file = NULL, type = "message")

close(file_out)
close(file_err)

rm(list=ls())
