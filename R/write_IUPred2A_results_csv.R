#' Write a .results File from the IUPred2A Webservice as a Data Frame
#' 
#' @description Given a file of disordered protein regions results from the
#'   IUPred2A online calculator, write these results to a \code{.csv} file
#'
#' @param inFile File path to a \code{.results} file saved on your local machine
#' @param outFile File path to write the \code{.csv} file
#' @param colNameRow Which row has the column names? Defaults to 5, but this
#'   may need to be adjusted if the \code{.results} file format changes.
#' @param delim Within each protein, what is the results delimiter? Defaults to
#'   \code{"\\t"}, which indicates the tablular data are tab delimited.
#'
#' @details This function works in 4 main chunks: 1) import the data and extract
#'   the (future) column names; 2) split the character strings (one per row)
#'   into groups based on the protein (FASTA name); 3) transform these groups of
#'   character strings into a character matrix, one per protein; 4) add back 
#'   the protein names and column names and "stack" all matrices into one
#'
#' @return Nothing. Writes a \code{.csv} file with columns for the FASTA header
#'   and IUPred2A output (such as the position, amino acid, and discordance
#'   scores)
#'
#' @importFrom stringr str_sub str_split str_replace_all
#' @importFrom utils write.csv
#' @export
#'
#' @examples
#' \dontrun{
#'   write_IUPred2A_results_csv(
#'     inFile  = "inst/extdata/data_raw/COMBINED_BLAST2_MUSCLE.result",
#'     outFile = "inst/extdata/data_clean/muscle_BLAST2_results_20220422.csv"
#'   )
#' }
#'   
write_IUPred2A_results_csv <- function(inFile, outFile,
                                       colNameRow = 5L, delim = "\t") {
  # browser()
  
  
  ###  Input Data  ###
  input_char <- readLines(inFile)
  
  # Column names: remove leading "# " and split
  colNames_char <- str_sub(input_char[colNameRow], start = 3, end = -1)
  colNames_char <- str_split(colNames_char, pattern = delim)[[1]]
  colNames_char <- str_replace_all(
    colNames_char, pattern = " ", replacement = "_"
  )
  
  # Remove repeated metadata rows
  dropLines_lgl <- str_sub(input_char, start = 1L, end = 1L) %in% c("#", "")
  results_char <- input_char[!dropLines_lgl]
  rm(input_char); gc() # keep the memory imprint low
  
  
  
  ###  Split Data by FASTA Headers  ###
  whichHeaders_lgl <- str_sub(results_char, start = 1L, end = 1L) == ">"
  groups_idx <- cumsum(whichHeaders_lgl)
  
  # Split the results into a list to preserve the header
  split_ls <- vector(mode = "list", length = length(unique(groups_idx)))
  proteins_char <- results_char[whichHeaders_lgl]
  names(split_ls) <- proteins_char
  
  # Iterate over Protein
  for( res in unique(groups_idx) ) {
    
    rowsInGroup_lgl <- groups_idx == res
    resultInGroup_char <- results_char[rowsInGroup_lgl]
    split_ls[[res]] <- resultInGroup_char[-1] # remove protein names
    
  }
  rm(results_char); gc()
  
  
  
  ###  Wrangle the Protein Strings  ###
  # NOTE 2022-04-22: this whole operation is like 5 lines using the Tidyverse,
  #   but I want to depend on those packages as little as possible. For the 
  #   interactive version which uses the Tidyverse, see the script 
  #   "inst/scripts/import_IUPred2A_results_20220420.R"
  
  # Split character to matrix
  resultsMat_ls <- lapply(
    X = split_ls,
    FUN = str_split,
    pattern = delim,
    simplify = TRUE
  )
  
  # Replace row numbers with protein / FASTA header; add column names
  colNames_char[1] <- "FASTA_HEADER"
  for( i in seq_along(resultsMat_ls) ) {
    
    resultsMat_ls[[i]][, 1] <- proteins_char[i]
    colnames(resultsMat_ls[[i]]) <- colNames_char
    
  }
  
  
  
  ###  Write to Disk  ###
  # Stack and Change to Data Frame
  results_mat <- do.call(rbind, resultsMat_ls)
  
  write.csv(results_mat, file = outFile, row.names = FALSE)
  
}
