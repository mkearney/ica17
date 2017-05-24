## Functions for building/organizing this repository

## knit Rmd files

rmds <- list.files(pattern = "\\.Rmd$")
sh <- Map(knitr::render_html)
