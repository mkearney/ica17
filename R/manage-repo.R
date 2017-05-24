## Functions for building/organizing this repository

## knit Rmd files


md2docs <- function() {
    rmds <- list.files(pattern = "\\.Rmd$")
    sh <- Map(knitr::knit, rmds)
    mds <- list.files(pattern = "\\.md")
    m2d_internal <- function(x) {
        sh <- system(paste("mv", x, "../docs"))
    }
    sh <- Map(m2d_internal, mds)
    message("markdown files moved to docs!")
}

md2docs()

