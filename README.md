
# msaHelper: Helper Functions for Multiple Sequence Alignment

<!-- badges: start -->
<!-- badges: end -->

The goal of `msaHelper` is to ...


## Installation

You can install the development version of msaHelper from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("gabrielodom/msaHelper")
```


## Input Data
A `.fasta` file in `extdata/data_raw` is a multiple sequence alignment file generated using the MUSCLE algorithm in [Jalview](https://www.jalview.org/). The `.result` file is generated using multiple sequence alignment `.fasta` file and inputting into the [IUPRED webserver](https://iupred2a.elte.hu/) for position specific disorder scoring.

The goal of this project is to create a similar alignment file, where the scores generated from the IUPRED web server are mapped individually to each position on the multiple sequence alignment. This score can then be used to visualize propensity for disorder through a heat map.


## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(msaHelper)
## basic example code
```

