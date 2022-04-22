# Create Disorder Heat Map
# Hiram Duarte and Gabriel Odom
# 2022-04-22


###  Setup  ###
library(tidyverse)

disorder_df <- read_csv(file = "inst/extdata/data_clean/disorder_20220420.csv")


###  Wrangle  ###
# First we need to set the column of fasta headers into row names
disorder2_df <- column_to_rownames(disorder_df, "FASTA_HEADER")
disorder2_df[1:5, 1:5]

# Now that the FASTA headers are row names, we can convert the results into a
#    numeric matrix that can be used for a heat map.
disorder_mat <- as.matrix(disorder2_df)


###  Heatmaps  ###
# Creating the heatmap
heatmap(disorder_mat)

# The columns are re-ordered (but we want to preserve the position)
heatmap(disorder_mat, Colv = NA)

# TO DO: get the correct row clusters from the phylogenetic tree, then order
#   the rows of this heatmap accordingly
