library(tidyverse)
library(dplyr)

# We are importing our csv's created in our last scripts
FASTA_File <- read_csv("inst/extdata/data_clean/muscle_BLAST2_FASTA_20220420.csv")

Results_File <- read_csv("inst/extdata/data_clean/muscle_BLAST2_results_20220420.csv")

# Here we are grouping our sequences by fasta header, as they are in list format.
# Then we are going to mutate our data set so that there are position numbers that are tied to our amino acids
# Finally, pivot wider is going to turn each of our individual amino acids into columns.
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

# Here we turn our newly created dataframe into a csv file

write_csv(disorder_df, file = "inst/extdata/data_clean/disorder_20220420.csv")
