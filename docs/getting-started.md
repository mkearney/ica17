---
output: github_document
---





## Getting started with rtweet

### Installing rtweet

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
devtools::install_github("mkearney/rtweet", build_vignettes = TRUE)
```

### Authorizing access to Twitter's APIs

I've tried to make the API token [oauth] process as painless as
possible. That's why I've included the "auth" vignette, which ships
with the package and contains step-by-step instructions on how to
create and manage your Twitter API token. The vignette also includes
instructions for saving a token as an environment variable, which
automates the token-loading process for all future sessions (at least,
for the machine you're using). View the
[authorization vignette online](https://mkearney.github.io/rtweet/articles/auth.html)
or enter the following code into your R console to load the vignette locally:


```r
## Open Twitter token vignette in web browser.
vignette(topic = "auth", package = "rtweet")
```

### Package documentation

In addition to the API authorization vignette, rtweet also includes a
[brief package overview vignette](https://mkearney.github.io/rtweet/articles/intro.html)
as well as a
[vignette demonstrating how to access Twitter's stream API](https://mkearney.github.io/rtweet/articles/stream.html). To
open the vignettes locally, use the code below.


```r
## overview of rtweet
vignette(topic = "intro", package = "rtweet")

## accessing Twitter's stream API
vignette(topic = "stream", package = "rtweet")
```

And thanks to Hadley et al.'s
[pkgdown package](https://github.com/hadley/pkgdown) rtweet now has a
dedicated
[package documentation website](https://mkearney.github.io/rtweet). If
you'd like to contribute to rtweet, or if you run into any bugs, users
are encouraged to
[create an issue](https://github.com/mkearney/rtweet/issues) on
[rtweet's Github page](https://github.com/mkearney/rtweet).

### Searching for tweets

Searching for tweets is easy.


```r
## load rtweet
library(rtweet)

## search for tweets containing ICA17 or ICA2017 (not case sensitive)
ica17 <- search_tweets("#ica17 OR #ica2017", n = 10000, include_rts = FALSE)
```

If you haven't downloaded ggplot2 yet, the plot that's created will
look a little different than the plot below. That's because ggplot2 is
only listed as a *recommended* (not required) package. If ggplot2 is
installed on your machine, then `ts_plot` will return a ggplot object,
which can be modified like any ggplot.


```r
## plot a time series of tweets, aggregating by one-hour intervals
p1 <- ts_plot(ica17, "hours") +
    ggplot2::labs(
        x = "Date and time of tweets",
        y = "Frequency of tweets",
        title = "Time series of #ICA17 tweets",
        subtitle = "Frequency of Twitter statuses calculated in one-hour intervals."
    ) +
    theme_ica17()
p1
```

<p align="center">
<img src="img/p1.png" alt="p1">
</p>


## Analyzing text


```r
## strip text of tweets
plain_tweets(ica17$text[1:10])
```

```
##  [1] "good news finally on the train down to san diego for"                                                   
##  [2] "grest to be in sunny and happy san diego for looking foreard to intellectual nourishment and having fun"
##  [3] "its a tough life here at the in san diego"                                                              
##  [4] "hey grad students early career scholars remember to join us on monday morning"                          
##  [5] "conversely the webpage says our mtg goes to the reception starts at requiring us all to develop clones" 
##  [6] "off to see some tunes before reconnecting with colleagues alums at oh and presenting research"          
##  [7] "can you hear me now phreaking the party line from operators to occupy by"                               
##  [8] "thanks to for some herculean livetweeting from today looking forward to day program"                    
##  [9] "civic engagement means no shortcuts if we want to make freedom ring we have to phreak democracy"        
## [10] "business mtg reception on sunday"
```

```r
## tokenize by word
plain_tweets(ica17$text[1:10], tokenize = TRUE)
```

```
## [[1]]
##  [1] "good"    "news"    "finally" "on"      "the"     "train"  
##  [7] "down"    "to"      "san"     "diego"   "for"    
## 
## [[2]]
##  [1] "grest"        "to"           "be"           "in"          
##  [5] "sunny"        "and"          "happy"        "san"         
##  [9] "diego"        "for"          "looking"      "foreard"     
## [13] "to"           "intellectual" "nourishment"  "and"         
## [17] "having"       "fun"         
## 
## [[3]]
##  [1] "its"   "a"     "tough" "life"  "here"  "at"    "the"   "in"   
##  [9] "san"   "diego"
## 
## [[4]]
##  [1] "hey"      "grad"     "students" "early"    "career"   "scholars"
##  [7] "remember" "to"       "join"     "us"       "on"       "monday"  
## [13] "morning" 
## 
## [[5]]
##  [1] "conversely" "the"        "webpage"    "says"       "our"       
##  [6] "mtg"        "goes"       "to"         "the"        "reception" 
## [11] "starts"     "at"         "requiring"  "us"         "all"       
## [16] "to"         "develop"    "clones"    
## 
## [[6]]
##  [1] "off"          "to"           "see"          "some"        
##  [5] "tunes"        "before"       "reconnecting" "with"        
##  [9] "colleagues"   "alums"        "at"           "oh"          
## [13] "and"          "presenting"   "research"    
## 
## [[7]]
##  [1] "can"       "you"       "hear"      "me"        "now"      
##  [6] "phreaking" "the"       "party"     "line"      "from"     
## [11] "operators" "to"        "occupy"    "by"       
## 
## [[8]]
##  [1] "thanks"       "to"           "for"          "some"        
##  [5] "herculean"    "livetweeting" "from"         "today"       
##  [9] "looking"      "forward"      "to"           "day"         
## [13] "program"     
## 
## [[9]]
##  [1] "civic"      "engagement" "means"      "no"         "shortcuts" 
##  [6] "if"         "we"         "want"       "to"         "make"      
## [11] "freedom"    "ring"       "we"         "have"       "to"        
## [16] "phreak"     "democracy" 
## 
## [[10]]
## [1] "business"  "mtg"       "reception" "on"        "sunday"
```

```r
## get word counts
wrds <- plain_tweets(ica17$text, tokenize = TRUE)
wrds <- table(unlist(wrds))

## view top 10 words
head(sort(wrds, decreasing = TRUE), 10)
```

```
## 
## the  to  of and  in for  on   a  at  is 
## 334 288 201 189 184 178 142 127 125  87
```

We can create our own dictionary of stop words by locating overlap
between our sample and a more general sample of tweets. We can get a
more general sample by searching for each letter in the alphabet with
separated by ` OR ` (boolean logic used by Twitter). I've done that
below to get five thousand tweets.



```r
## construct boolean-exploiting search query
all <- paste(letters, collapse = " OR ")

## conduct search for 5,000 original (non-retweeted) tweets
sw <- search_tweets(all, n = 5000, include_rts = FALSE)
```


```r
## create freq table of all words from general pool of tweets
stopwords <- plain_tweets(sw$text, tokenize = TRUE)
stopwords <- table(unlist(stopwords))

## exclude all ica17 words that appear more than 5 times in stopwords
wrds <- wrds[!names(wrds) %in% names(stopwords[stopwords > 5L])]

## check top words again
head(sort(wrds, decreasing = TRUE), 40)
```

```
## 
##         diego        indigo      politics preconference    conference 
##            76            44            27            22            20 
##       forward      ballroom      altheide          join       excited 
##            20            18            17            17            16 
##      research       session      populism      schedule       digital 
##            16            16            15            15            14 
##          fear       hashtag        online     highfield           net 
##            14            14            14            13            13 
##        papers      populist     reception    technology    presenting 
##            13            13            13            13            12 
##      sapphire      congrats        friday        kraidy    litherland 
##            12            11            11            11            11 
##      oullette         paper         hearn           ica        mobile 
##            11            11            10            10            10 
##    munication         panel      students        trumps        yilmaz 
##            10            10            10            10            10
```

Create simple word cloud to visualize.


```r
## get some good colors
cols <- sample(rainbow(10, s = .5, v = .75), 10)

## plot word cloud
par(bg = "black")
wordcloud::wordcloud(
    words = names(wrds),
    freq = wrds,
    random.color = FALSE,
    colors = cols,
    family = "Roboto Condensed",
    scale = c(4.5, .4))
```

<p align="center">
<img src="img/p2.png" alt="p2">
</p>

### Tracking topic salience


```r
## search for tweets about the CBO (released on Wed.)
cbo <- search_tweets(
    "CBO health care", n = 18000, include_rts = FALSE)

## search tweets mentioning north korea (missle test on Monday)
nk <- search_tweets(
    "north korea", n = 18000, include_rts = FALSE)

## cbind into one data frame
df <- rbind(cbo, nk)
```



```r
## create plain tweets variable
df$text_plain <- plain_tweets(df$text)

## filter by search topic
p3 <- ts_plot(df, by = "15 mins",
             filter = c("cbo|health|care|bill|insured|deficit|budget",
                        "korea|kim|jung un|missile"),
             key = c("CBO", "NKorea"),
             txt = "text_plain")

## add theme and style plot
p3 <- p3 + theme_ica17() +
    geom_line(size = 1) +
    scale_color_manual(values = c("#cc1111", "#0022cc")) +
    theme(legend.title = element_blank()) +
    scale_x_datetime(date_labels = "%b %d %H:%m") +
    labs(x = NULL, y = NULL, title = "Tracing topic salience in Twitter statuses",
         subtitle = "Tweets (N = 23,467) were aggregated in 15-minute intervals. Retweets were not included.")

p3
```

<p align="center">
<img src="img/p3.png" alt="p3">
</p>
