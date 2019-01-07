#This script installs the packages and prerequisites to run DESeq

#Set timezone
Sys.setenv(TZ="US/Eastern")

#Install packages to support R Markdown
install.packages("knitr")
install.packages("RColorBrewer", quiet = T)
install.packages("devtools")
install.packages("pheatmap",quiet = T)

#Set the source to Bioconductor
source("https://bioconductor.org/biocLite.R")
biocLite("BiocUpgrade")

#Install DESeq2
biocLite("DESeq2")
#Install limma for Venn Diagrams
biocLite("limma")
