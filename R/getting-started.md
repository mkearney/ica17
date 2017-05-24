---
output: github_document
---




## Getting started with rtweet

Install from CRAN using `install.packages`.


```r
## install from CRAN
install.packages("rtweet")
```

Alternatively, install the most recent [development] version from
Github using `install_github` (from the devtools package).



```r
## install from Github (dev version)
if (!"devtools" %in% installed.packages()) {
    install.packages("devtools")
}
devtools::install_github("mkearney/rtweet")
```

I've tried to make the API token [oauth] process as painless as
possible. In fact, rtweet comes bundled with a dedicated token, so
users can start collecting Twitter data in seconds.


```r
ica17 <- search_tweets("#ICA17", n = 500)
ts_plot(ica17)
```

The bundled functionality should only be thought of as a test
drive. There's no guarantee it will work as expected. Instead, users
should create their own Twitter API tokens. I've laid out step by step
instructions in the
[auth vignette](https://mkearney.github.io/rtweet/articles/auth.html).
This vignette also includes instructions for saving your token as an
environment variable, which means you'll never have to worry about API
authorization again (at least on the machine you're currently using)!

