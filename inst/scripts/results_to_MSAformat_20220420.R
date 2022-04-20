library(tidyverse)
library(dplyr)

FASTA_File <- read_csv("inst/extdata/data_clean/muscle_BLAST2_FASTA_20220420.csv")

Results_File <- read_csv("inst/extdata/data_clean/muscle_BLAST2_results_20220420.csv")

disorder_df <- 
  Results_File %>%
  select(FASTA_HEADER, AMINO_ACID) %>%
  group_by(FASTA_HEADER) %>%
  mutate(POSITION_NUMBER = as.character(1:n())) %>% 
  mutate(
    POSITION_NUMBER = str_pad(POSITION_NUMBER, side = "left", width = 4, pad = "0")
  ) %>% 
  mutate(POSITION_NUMBER = paste0("pos_", POSITION_NUMBER)) %>% 
  pivot_wider(names_from = POSITION_NUMBER, values_from = AMINO_ACID)
  
write_csv(disorder_df, file = "inst/extdata/data_clean/disorder_20220420.csv")
