
install.packages("devtools")

library(devtools)

install_github("gluck4668/LXidconvert")

library(LXidconvert)

#--------------------------------
data(gene_data_example)
data(protein_ENS_id)
data(protein_Uniprot_id)
data(meta_data_example)
#--------------------------------

rm(list=ls())

# devtools::load_all()

data_file = "gene_data.xlsx"

data_type="gene" # It should be "gene", "protein", or "metabolite"

from_id="SYMBOL"

to_id=c("UNIPROT", "ENSEMBL","ENTREZID","GENENAME")

species="rat" # It should be "rat","mouse", or "human"


LXidconvert (data_file,data_type,from_id,to_id,species)


#----查看gene id and protein id 类型------------------
keytypes(org.Hs.eg.db) # human id
keytypes(org.Rn.eg.db) # rat id
keytypes(org.Mm.eg.db) # mouse id

#----查看metabolite id类型----------------------------
valid_from <- unlist(valid_from())
valid_to <- unlist(valid_to())

head(valid_from)
head(valid_to)

 id01<-"Human Metabolome Database"
 valid_from[grepl(id01,valid_from,ignore.case=TRUE)]

 id02 <- "KEGG"
 valid_to[grepl(id02,valid_to,ignore.case=TRUE)]


