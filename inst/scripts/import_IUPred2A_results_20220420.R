# Split IUPred2A Results File
# Gabriel Odom and Hiram Duarte
# 2022-04-20

library(tidyverse)
results_char <- readLines("inst/extdata/data_raw/COMBINED_BLAST2_MUSCLE.result")

###  Drop lines with a "#"  ###
dropLines_lgl <- str_sub(results_char, start = 1L, end = 1L) %in% c("#", "")
results_char[dropLines_lgl]
# This drops the column names, so we will record them here:
# "# POS\tAMINO ACID\tIUPRED SCORE\tANCHOR SCORE"
# The column names are
colNames_char <- c("POS", "AMINO_ACID", "IUPRED_SCORE")

# Keep the lines that we don't drop
results2_char <- results_char[!dropLines_lgl]


###  Extract the FASTA header  ###
whichHeaders_lgl <- str_sub(results2_char, start = 1L, end = 1L) == ">"
groups_idx <- cumsum(whichHeaders_lgl)

# Split the results into a list to preserve the header
split_ls <- vector(mode = "list", length = length(unique(groups_idx)))
names(split_ls) <- results2_char[whichHeaders_lgl]
# We expect to see 30 different results

for( res in unique(groups_idx) ) {
  
  rowsInGroup_lgl <- groups_idx == res
  resultInGroup_char <- results2_char[rowsInGroup_lgl]
  split_ls[[res]] <- resultInGroup_char[-1]
  
}

# To data frame?
# read_delim(split_ls[[1]][1])  # wrong
str_split(split_ls[[1]], pattern = "\t", simplify = TRUE) # a matrix

results_df <- map_dfr(
  .x = split_ls,
  .f = ~{
    out_mat <- str_split(.x, pattern = "\t", simplify = TRUE)
    colnames(out_mat) <- c("row_num", colNames_char)
    as_tibble(out_mat)
  },
  .id = "FASTA_HEADER"
)


# Save
results_df %>% 
  select(-row_num) %>% 
  write_csv(
    file = "inst/extdata/data_clean/muscle_BLAST2_results_20220420.csv"
  )
