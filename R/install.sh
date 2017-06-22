#!/usr/bin/env bash
#
# Install R along with some useful R modules.

brew tap homebrew/science
brew install r
R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
R -e "install.packages('Rcpp', repos='http://cran.rstudio.com/')"
R -e "install.packages('dplyr', repos='http://cran.rstudio.com/')"
R -e "install.packages('reshape2', repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
