# Import and Wrangle FASTA
# Gabriel Odom and Hiram Duarte
# 2021-11-10



######  Try Out Read Options  #################################################
# Basic string option
library(tidyverse)
fasta_char <- read_lines("DVNP_psiblast.fasta")


# in gene context: seqinr:: package
# install.packages("seqinr")
library(seqinr)
fasta_ls <- read.fasta("DVNP_psiblast.fasta")

# in gene context: Biostrings:: package
install.packages("BiocManager")
# BiocManager::install("Biostrings")
library(Biostrings)
fasta_AAset <- readAAStringSet("DVNP_psiblast.fasta")
fasta_AAset[1:3]
names(fasta_AAset[1:3])
dim(fasta_AAset)
names(fasta_AAset[nchar(fasta_AAset) < 100])

# Given these three options, we will use the Biostrings package
writeXStringSet(
  x = fasta_AAset[nchar(fasta_AAset) >= 100],
  filepath = "DVNP_psiblast_trim100_20211110.fasta"
)

names(fasta_AAset)



######  Cleaning  #############################################################
library(Biostrings)
fasta_AAset <- readAAStringSet("DVNP_psiblast.fasta")

View(
  data.frame(
    string = names(fasta_AAset)
  )
)
