---
params:
  hashtag: '#birdoftheyear OR #boty' # <- for a different string just edit this & re-run
title: 'Twitter hashtag analysis: #birdoftheyear OR #boty'
author: "Ben Anderson (`@dataknut`)"
date: 'Last run at: 2018-10-01 12:09:56'
output:
  html_document:
    keep_md: yes
    number_sections: yes
    self_contained: no
    toc: yes
    toc_float: yes
  pdf_document:
    number_sections: yes
    toc: yes
    toc_depth: 3
bibliography: '/Users/ben/bibliography.bib'
---







# Purpose

To extract and visualise tweets and re-tweets of #birdoftheyear OR #boty in September/October 2018.

Borrowing extensively from https://github.com/mkearney/rtweet

We used the Twitter search API to extract 'all' tweets with the #birdoftheyear OR #boty hashtag in the 'recent' twitterVerse. 

It is therefore possible that not quite all tweets have been extracted although it seems likely that we have captured most `human` tweeting which was our main intention. Future work should instead use the Twitter [streaming API](https://dev.twitter.com/streaming/overview).

# Load Data

Load the pre-collected data.


```
##  [1] "user_id"                 "status_id"              
##  [3] "created_at"              "screen_name"            
##  [5] "text"                    "source"                 
##  [7] "display_text_width"      "reply_to_status_id"     
##  [9] "reply_to_user_id"        "reply_to_screen_name"   
## [11] "is_quote"                "is_retweet"             
## [13] "favorite_count"          "retweet_count"          
## [15] "hashtags"                "symbols"                
## [17] "urls_url"                "urls_t.co"              
## [19] "urls_expanded_url"       "media_url"              
## [21] "media_t.co"              "media_expanded_url"     
## [23] "media_type"              "ext_media_url"          
## [25] "ext_media_t.co"          "ext_media_expanded_url" 
## [27] "ext_media_type"          "mentions_user_id"       
## [29] "mentions_screen_name"    "lang"                   
## [31] "quoted_status_id"        "quoted_text"            
## [33] "quoted_created_at"       "quoted_source"          
## [35] "quoted_favorite_count"   "quoted_retweet_count"   
## [37] "quoted_user_id"          "quoted_screen_name"     
## [39] "quoted_name"             "quoted_followers_count" 
## [41] "quoted_friends_count"    "quoted_statuses_count"  
## [43] "quoted_location"         "quoted_description"     
## [45] "quoted_verified"         "retweet_status_id"      
## [47] "retweet_text"            "retweet_created_at"     
## [49] "retweet_source"          "retweet_favorite_count" 
## [51] "retweet_retweet_count"   "retweet_user_id"        
## [53] "retweet_screen_name"     "retweet_name"           
## [55] "retweet_followers_count" "retweet_friends_count"  
## [57] "retweet_statuses_count"  "retweet_location"       
## [59] "retweet_description"     "retweet_verified"       
## [61] "place_url"               "place_name"             
## [63] "place_full_name"         "place_type"             
## [65] "country"                 "country_code"           
## [67] "geo_coords"              "coords_coords"          
## [69] "bbox_coords"             "status_url"             
## [71] "name"                    "location"               
## [73] "description"             "url"                    
## [75] "protected"               "followers_count"        
## [77] "friends_count"           "listed_count"           
## [79] "statuses_count"          "favourites_count"       
## [81] "account_created_at"      "verified"               
## [83] "profile_url"             "profile_expanded_url"   
## [85] "account_lang"            "profile_banner_url"     
## [87] "profile_background_url"  "profile_image_url"      
## [89] "ba_obsDate"              "ba_obsTime"
```

The table has 5,045 tweets (including 308 quotes and 3,690 re-tweets) from 1,802 tweeters between 2018-09-18 and 2018-09-30.

# Analysis

## Tweets and Tweeters over time



![All (re)tweets and quotes containing #birdoftheyear OR #boty2018-09-18 to 2018-09-30](birdOfTheYear2018_files/figure-html/allDaysChart-1.png)


## Screen name

Next we'll try by screen name.

Here's a really bad visualisation of all tweeters tweeting over time. Each row of pixels is a tweeter (the names are probably illegible) and a green dot indicates a few tweets in the half hour while a red dot indicates a lot of tweets.

![N tweets per day minutes by screen name](birdOfTheYear2018_files/figure-html/screenNameAll-1.png)

Yeah, that worked well.

So let's re-do that for the top 50 tweeters so we can see their tweetStreaks...

Top tweeters:


Table: Top 15 tweeters (all days)

screen_name        nTweets
----------------  --------
birdoftheyear          193
coolbiRdpics            80
jackcraw57              63
testeeves               62
Forest_and_Bird         61
NatForsdick             60
mifflangstone           60
vote4kaki               55
thebushline             50
newzealandbirds         42
kiwilullaby             42
votebittern             33
Em_Rawson               33
votegannet              32
This_NZ_Life            28

And their tweetStreaks...

![N tweets per day minutes by screen name (top 50, reverse alphabetical)](birdOfTheYear2018_files/figure-html/screenNameTop50-1.png)

Any twitterBots...?

# About



Analysis completed in 23.319 seconds ( 0.39 minutes) using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with R version 3.5.1 (2018-07-02) running on x86_64-apple-darwin15.6.0.

A special mention must go to `twitteR` [@twitteR] for the twitter API interaction functions and `lubridate` [@lubridate] which allows time-zone manipulation without too many tears.

Other R packages used:

 * base R - for the basics [@baseR]
 * data.table - for fast (big) data handling [@data.table]
 * readr - for nice data loading [@readr]
 * ggplot2 - for slick graphs [@ggplot2]
 * plotly - fancy, zoomable slick graphs [@plotly]
 * twitteR - twitter API search [@twitteR]
 * knitr - to create this document [@knitr]

# References



