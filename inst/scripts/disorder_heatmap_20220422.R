# Create Disorder Heat Map
# Hiram Duarte and Gabriel Odom
# 2022-04-22

library(tidyverse)

# First we need to set the column of fasta headers into row names

column_to_rownames(disorder_df, "FASTA_HEADER")

# Now that the FASTA headers are row names, we can convert the results into a
#    numberical matrix that can be used for a heat map.

as.matrix(disorder_df)

# Creating the heatmap

heatmap(disorder_df)
