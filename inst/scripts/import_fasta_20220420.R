# Import and Wrangle FASTA
# Gabriel Odom and Hiram Duarte
# 2022-04-20

# Started work in scripts/import_fasta_20211110.R



######  Try Out Read Options  #################################################
# # Basic string option
# library(tidyverse)
# fasta_char <- read_lines("DVNP_psiblast.fasta")

# in gene context: Biostrings:: package
install.packages("BiocManager")
# BiocManager::install("Biostrings")
library(Biostrings)
fasta_AAset <- readAAStringSet(
  "inst/extdata/data_raw/COMBINED_BLAST2_MUSCLE.fasta"
)
fasta_AAset[1:3]
names(fasta_AAset[1:3])
dim(fasta_AAset)

# names(fasta_AAset[nchar(fasta_AAset) < 100])
# writeXStringSet(
#   x = fasta_AAset[nchar(fasta_AAset) >= 100],
#   filepath = "DVNP_psiblast_trim100_20211110.fasta"
# )



######  Wrangling  ############################################################
library(tidyverse)
muscleFASTA_df <- 
  fasta_AAset %>% 
  as.data.frame() %>% 
  rownames_to_column(var = "names") %>% 
  as_tibble() %>% 
  rename(seq = x) %>% 
  mutate(width = width(fasta_AAset)) %>% 
  # Include everything() just in case there are metadata columns we don't see
  select(width, seq, names, everything())

write_csv(
  muscleFASTA_df,
  "inst/extdata/data_clean/muscle_BLAST2_FASTA_20220420.csv"
)
  