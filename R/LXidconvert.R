
#-------------------------------------------------------------

LXidconvert <- function(data_file,data_type,from_id,to_id,species){

#---安装R包----------------
inst_packages <- function(){

installed_packs <- installed.packages()[,1]
com_packs <- c("openxlsx","tidyr","purrr","httr","RSQLite","reshape2",
               "shiny","dbplyr","AnnotationDbi","stats4","BiocGenerics",
               "Biobase","IRanges","S4Vectors","devtools")
bio_packs <- c("clusterProfiler","org.Rn.eg.db","org.Mm.eg.db","org.Hs.eg.db")
git_packs <- c("CTSgetR")

not_com <- com_packs[!com_packs %in% installed_packs]
if(length(not_com)>0){
  com_fun <- function(i){install.packages(i)}
  sapply(com_packs,com_fun)
  }

not_bio <- bio_packs[!bio_packs %in% installed_packs]
if(length(not_bio)>0){
  bio_fun <- function(i){BiocManager::install(i,update = F,ask = F)}
  sapply(bio_packs,bio_fun)
  }

not_git <- git_packs[!git_packs %in% installed_packs]
if(length(not_git)>0){
  library(devtools)
  install_github("dgrapov/CTSgetR")
  }

lib_fun <- function(i){library(i,character.only = T)}
sapply(c(com_packs,bio_packs,git_packs),lib_fun)
}

inst_packages()

# https://github.com/dgrapov/CTSgetR
# library(devtools)
# install_github("dgrapov/CTSgetR")

# -----------CTSgetR基本用法-------------------------
# CTSgetR(id, from, to, db_name = NULL, ...)
# id：需要转换的代谢物ID列表
# from：输入的代谢物ID的标识符类型
# to：需要转换成的代谢物标识符类型
# db_name：sqlite数据库存储缓存结果的字符串路径（可加快转换速度）

# --------------确认CTS API可用----------------------
# GET('https://cts.fiehnlab.ucdavis.edu/services') %>%
#  http_status(.) %>%
#  {if( .$category != 'Success'){stop('Oops looks like https://cts.fiehnlab.ucdavis.edu/services is down!') }}

# -----------查看可用数据库（展示部分）--------------
# head(unlist(valid_from()))
# head(unlist(valid_to()))
# from_df=unlist(valid_from())
# to_df= unlist(valid_to())


#------------ 查找名称-----------------------------
# want<-'KEGG'
# from_df[grepl(want,from_df,ignore.case=TRUE)]
# to_df[grepl(want,to_df,ignore.case=TRUE)]

# want<-"Human Metabolome Database"
# from_df[grepl(want,from_df,ignore.case=TRUE)]
# to_df[grepl(want,to_df,ignore.case=TRUE)]

# want<-"compound"
# from_df[grepl(want,from_df,ignore.case=TRUE)]
# to_df[grepl(want,to_df,ignore.case=TRUE)]

# ---------示例：----------------------------------
# CTSgetR(id = c("C00026","C05381"),from = "KEGG",
#        to = c("Human Metabolome Database","PubChem CID"))

# CTSgetR(id = c("alanine",'lactic acid'),from = "Chemical Name",
#        to = c("KEGG","Human Metabolome Database","PubChem CID"))


# hmdb_list <- read.xlsx("meta_list.xlsx")
# conv_id <- CTSgetR(id = hmdb_list[,1],from = "Human Metabolome Database",to = c("KEGG","PubChem CID"))

#-----读取数据-------------------------------------------------------------
spe_all <- c("rat","mouse", "human")
if(!grepl(trimws(species),spe_all,ignore.case = T) %>% any())
  stop("The species is error！It should be rat, mouse, or human. Please check it.")

dir.name <- c("analysis_resut")
if(!dir.exists(dir.name))
 dir.create(dir.name)

df <- read.xlsx(data_file)
names(df)[1] <-"from_id"
df <- distinct(df,from_id,.keep_all = T)


#----gene or protein id convert---------------------------------------------
if( tolower(trimws(data_type))=="gene" | tolower(trimws(data_type))=="protein" )
  {
  org.db <-case_when(tolower(trimws(species))=="human" ~ "org.Hs.eg.db",
                     tolower(trimws(species))=="rat" ~ "org.Rn.eg.db",
                     tolower(trimws(species))=="mouse" ~ "org.Mm.eg.db"
                    )

   id_convert <- bitr(geneID = df$from_id,
                           fromType = trimws(from_id),
                           toType = trimws(to_id),
                           OrgDb = org.db)

  } else

#-------metabolite数据处理-----------------------
id_convert <- CTSgetR(id = df$from_id,from = trimws(from_id),to = trimws(to_id) ) %>% data.frame()

#-------导出转换后的文件-------------------------
file_name <- paste0(dir.name,"/",gsub("[.].*","",data_file),"_to_",trimws(to_id)[1],".xlsx" )

write.xlsx(id_convert,file_name )

print("The converted ID file can be found in the folder of <analysis_resut>")

}

