
library(openxlsx)
gene_data_example <- read.xlsx("gene_data.xlsx")
protein_ENS_id <- read.xlsx("protein_ENS_id.xlsx")
protein_Uniprot_id <- read.xlsx("protein_Uniprot_id.xlsx")
meta_data_example <- read.xlsx("meta_data.xlsx")

usethis::use_data(gene_data_example,overwrite = T)
usethis::use_data(protein_ENS_id,overwrite = T)
usethis::use_data(protein_Uniprot_id,overwrite = T)
usethis::use_data(meta_data_example,overwrite = T)

rm(list=ls())

data(gene_data_example)
data(protein_ENS_id)
data(protein_Uniprot_id)
data(meta_data_example)


