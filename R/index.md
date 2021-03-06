
Intro to rtweet
===============

Twitter data
------------

Twitter data was already trendy, but the unpresidented 2016 U.S. election has elevated it to a fever pitch. One of the biggest drivers of the trend is the widespread availability of Twitter data. Twitter makes much of its user-generated data freely available to the public via Application Program Interfaces (APIs). APIs refer to sets of protocols and procedures for interacting with sites. Twitter maintains several APIs. The two most condusive to data collection are the REST API and the stream API, both of which I describe below.

Twitter's REST API provides a set of protocols for exploring and interacting with Twitter data related to user statuses (tweets), user profiles and timelines, and user network connections. The data are restful in that they have been archived by Twitter. Navigating these resting endpoints can, at times, be resource intensive, but it also makes it possible to perform highly complex and specific queries.

Twitter data not yet archived and accessible via the REST API can be accessed using Twitter's stream API. As its name suggests, the stream API provides users with a live stream of Twitter data. Because the data are streamed, or pushed, to the user, the stream API reduces overhead associated with performing queries on archived data sources. This makes it possible to collect large amounts of data very quickly and with relatively little strain on computational resources. The downside to the stream API is that it is limited to prospective (tracking, monitoring, etc.) but not retrospective (surveying, searching, etc.) queries.

Installing rtweet
-----------------

Install from CRAN using `install.packages`.

``` r
## install from CRAN
install.packages("rtweet")
```

Alternatively, install the most recent \[development\] version from Github using `install_github` (from the devtools package).

``` r
## install from Github (dev version)
if (!"devtools" %in% installed.packages()) {
    install.packages("devtools")
}
devtools::install_github("mkearney/rtweet", build_vignettes = TRUE)
```

Authorizing access to Twitter's APIs
------------------------------------

I've tried to make the API token \[oauth\] process as painless as possible. That's why I've included the "auth" vignette, which ships with the package and contains step-by-step instructions on how to create and manage your Twitter API token. The vignette also includes instructions for saving a token as an environment variable, which automates the token-loading process for all future sessions (at least, for the machine you're using). View the [authorization vignette online](https://mkearney.github.io/rtweet/articles/auth.html) or enter the following code into your R console to load the vignette locally:

``` r
## Open Twitter token vignette in web browser.
vignette(topic = "auth", package = "rtweet")
```

Package documentation
---------------------

In addition to the API authorization vignette, rtweet also includes a [brief package overview vignette](https://mkearney.github.io/rtweet/articles/intro.html) as well as a [vignette demonstrating how to access Twitter's stream API](https://mkearney.github.io/rtweet/articles/stream.html). To open the vignettes locally, use the code below.

``` r
## overview of rtweet package
vignette(topic = "intro", package = "rtweet")

## accessing Twitter's stream API
vignette(topic = "stream", package = "rtweet")
```

And thanks to [pkgdown](https://github.com/hadley/pkgdown), rtweet now has a dedicated [package documentation website](https://mkearney.github.io/rtweet). \*Btw, while I'm on the subject of package documentation/maintenance, I'd also like to point out [rtweet's Github page](https://github.com/mkearney/rtweet). Contributions are welcome and if you run into any bugs or other issues, users are encouraged to [create an Github issue](https://github.com/mkearney/rtweet/issues).

Searching for tweets
--------------------

Searching for tweets is easy. For example, we could search for all \[publically\] available statuses from the past 7-10 days that use the hashtags `#ica17` or `#ica2017`. In the code below I've specified 18,000 statuses (tweets), which is the maximum number a user may request every 15 minutes.

``` r
## load rtweet
library(rtweet)

## search for tweets containing ICA17 or ICA2017 (not case sensitive)
ica17 <- search_tweets(
    "#ica17 OR #ica2017", n = 18000, include_rts = FALSE
)
```

If there were more than 18,000 statuses that (a) fit the search query and (b) exist in the last 7-10 days (the limit put in place by Twitter), then users can continue where they left off by using the `max_id` parameter. Since Twitter statuses are returned in order from newest to oldest, the `max_id` value should just be the last status ID returned by the previous search.

``` r
## select last (oldest) status ID from previous search
last_status_id <-  ica17$status_id[nrow(ica17)]

## pass last_status_id to max_id and run search again.
ica17_contd <- search_tweets(
    "ica17 OR #ica2017", n = 18000, include_rts = FALSE,
    max_id = last_status_id
)
```

### Tweets data

Data returned by `search_tweets` is quite extensive. One recently added feature makes navigating the data a bit easier. As of version 0.4.3, *rtweet* returns `tibble` data frames (assuming the user has installed the *tibble* package, which is a dependency for nearly all packages in the tidyverse). Tibbles are especially nice when working with larger data sets because accidental printing in R has been known to take years off of one's life (needs citation).

#### ts\_filter and ts\_plot

Included in the rtweet package are a few convenenience functions, which have been designed to assist in the analysis of Twitter data. One of these convenient functions is `ts_plot`, which is a plot-based wrapper around `ts_filter`. The `ts_plot` and `ts_filter` functions aggregate the frequency of tweets over specified intervals of time. Hence, the "ts" (time series) naming convention. In addition to aggregating the frequency of statuses, `ts_plot` will also plot the time series.

The plot produced by `ts_plot` depends on whether the user has installed *ggplot2*, which is a suggested but not required package dependency for *rtweet*. If you haven't installed *ggplot2* then I highly recommend it. Assuming you have, then the object returned by `ts_plot` can be treated like any other ggplot object, meaning you can easily add layers and customize the plot to your liking.

``` r
## load ggplot2
library(ggplot2)

## aggregate freq of tweets in one-hour intervals
agg <- ts_filter(ica17, by = "hours")


## plot a time series of tweets, aggregating by one-hour intervals
p1 <- ts_plot(ica17, "hours") +
    ggplot2::labs(
        x = "Date and time",
        y = "Frequency of tweets",
        title = "Time series of #ICA17 tweets",
        subtitle = "Frequency of Twitter statuses calculated in one-hour intervals."
    ) +
    ## a custom ggplot2 theme I mocked up for ICA
    theme_ica17()

## render plot
p1
```

<p align="center">
<img src="img/p1.png" alt="p1">
</p>
Analyzing text
--------------

The second convenenience function for analysing tweets is `plain_tweets`. As you might guess, `plain_tweets` strips the text of the tweets down to plain text. Because there are already variables included in the default tweets data that contain links, hashtags, and mentions, those entities are stripped out of the text as well. What's returned are lower case words. Below I've applied the function to the first 10 ICA17 tweets.

``` r
## strip text of tweets
plain_tweets(ica17$text[1:10])
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

The `plain_tweets` function is relatively straight forward at cutting through the clutter, but it still may not prepare you for quick and easy analysis. For that, you can use the `tokenize` argument in `plain_tweets`. The tokenize argument will return a vector of plain text words for each tweet.

``` r
## tokenize by word
wrds <- plain_tweets(ica17$text, tokenize = TRUE)
wrds[1:10]
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

This can easily be converted into a word count \[frequency\] table, but it still leaves one problem. The most common words probably aren't going to tell us a lot about our specific topic / set of tweets.

``` r
## get word counts
wrds <- table(unlist(wrds))

## view top 10 words
head(sort(wrds, decreasing = TRUE), 10)
```

    ## 
    ## the  to  of and  in for  on   a  at  is 
    ## 334 288 201 189 184 178 142 127 125  87

See, these words don't appear to be very unique to ICA 2017. Of course, we could always find a premade list of stopwords to exclude, but those may not appropriately reflect the medium (Twitter) here. With rtweet, however, it's possible to create your own dictionary of stopwords by locating overlap between (a) a *particular* sample of tweets of interest and (b) a more *general* sample of tweets.

To do this, we're going to search for each letter of the alphabet separated by the boolean `OR`. It's a bit hacky, but it returns massive amounts of tweets about a wide range of topics. So, if we can identify the *unique* words used in our sample, we may yet accomplish our goal.

In the code below, I've excluded retweets since those add unnecessary redundancies (and, ideally, we'd want a diverse pool of tweets). It's still not perfect, but it gives us a systematic starting point that I imagine could be developed into a more reliable method.

``` r
## construct boolean-exploiting search query
all <- paste(letters, collapse = " OR ")

## conduct search for 5,000 original (non-retweeted) tweets
sw <- search_tweets(all, n = 5000, include_rts = FALSE)
```

``` r
## create freq table of all words from general pool of tweets
stopwords <- plain_tweets(sw$text, tokenize = TRUE)
stopwords <- table(unlist(stopwords))
```

Now that we've identified the frequencies of words in this more general pool of tweets, we can exclude all ICA tweet words that appear more than N number of times in the general pool.

``` r
## cutoff
N <- 5L

## exclude all ica17 words that appear more than N times in stopwords
wrds <- wrds[!names(wrds) %in% names(stopwords[stopwords > N])]

## check top words again
head(sort(wrds, decreasing = TRUE), 40)
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

That turned out well! These words look a lot more unique to the topic. We can quickly survey all of these words with a simple word cloud.

``` r
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
Tracking topic salience
-----------------------

If we wanted to model the topics of tweets, we could conduct two searches for tweets over the same time period and then compare the frequencies of tweets over time using time series. That's what I've done in the example below.

First I searched for tweets mentioning "North Korea", since I know they conducted another missile test on Monday.

``` r
## search tweets mentioning north korea (missle test on Monday)
nk <- search_tweets(
    "north korea", n = 18000, include_rts = FALSE)
```

Then I searched for tweets mentioning "CBO health care" (in any order, anywhere in the tweet), since I know the CBO was released on Wednesday.

``` r
## search for tweets about the CBO (released on Wed.)
cbo <- search_tweets(
    "CBO health care", n = 18000, include_rts = FALSE)
```

And then I combined the two data sets into one big data frame.

``` r
## cbind into one data frame
df <- rbind(cbo, nk)
```

Using the `ts_plot` function, I then provide a list of `filter` words (via regular expression; the bar is like an "OR"). Use the `key` argument if you want to have nicer looking filter labels. By default `ts_plot` will create groups based on the text of the tweet and the filters provided. However, you can pass along the name of any variable in DF and the function will use that to classify groups. In the code below, I applied `plain_tweets` to the text to create a new variable, and then specified that I wanted to apply the filters to that variable by using the `txt` argument in `ts_plot`.

``` r
## create plain tweets variable
df$text_plain <- plain_tweets(df$text)

## filter by search topic
p3 <- ts_plot(df, by = "15 mins",
             filter = c("cbo|health|care|bill|insured|deficit|budget",
                        "korea|kim|jung un|missile"),
             key = c("CBO", "NKorea"),
             txt = "text_plain")
```

Now it's easy to add more layers and make this plot look nice.

``` r
## add theme and style plot
p3 <- p3 + theme_ica17() +
    geom_line(size = 1) +
    scale_color_manual(values = c("#cc1111", "#0022cc")) +
    theme(legend.title = element_blank()) +
    scale_x_datetime(date_labels = "%b %d %H:%m") +
    labs(x = NULL, y = NULL, title = "Tracing topic salience in Twitter statuses",
         subtitle = "Tweets (N = 23,467) were aggregated in 15-minute intervals. Retweets were not included.")

## render plot
p3
```

<p align="center">
<img src="img/p3.png" alt="p3">
</p>
And that's it!
