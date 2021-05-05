# search geographic twitter data for Hurricane Dorian
# by Nick Nonnenmacher, 2021
# This code requires a twitter developer API token!
# See https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html

# install packages for twitter querying and initialize the library
packages = c("rtweet","here","dplyr","rehydratoR")
setdiff(packages, rownames(installed.packages()))
install.packages(setdiff(packages, rownames(installed.packages())),
                 quietly=TRUE)

library(rtweet)
library(here)
library(dplyr)
library(rehydratoR)

twitter_token = create_token(
  app = "",                     #enter your app name in quotes
  consumer_key = "",  		      #enter your consumer key in quotes
  consumer_secret = "",         #enter your consumer secret in quotes
  access_token = NULL,
  access_secret = NULL
)


<<<<<<< HEAD
#get tweets for Georgia tornado, searched on May 5, 2021
tornado <- search_tweets("tornado OR Atlanta OR mswx OR TXwx", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)

#get tweets without any text filter for the same geographic region in March, searched on May 5, 2021 (what does this accomplish??)
#the query searches for all verified or unverified tweets, so essentially everything
march <- search_tweets("-filter:verified OR filter:verified", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)

# load data into folder
load(here("data","derived","private","name_here"))
