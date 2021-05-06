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
  app = "Open Source GIScience",                     #enter your app name in quotes
  consumer_key = "HSF9cPtTb0GOoxO5RO2BYry9k",  		      #enter your consumer key in quotes
  consumer_secret = "Rn9P8dWPWANJMZHKk86WvB40Toi433KGBDOJTAmEbToRBBVPje",         #enter your consumer secret in quotes
  access_token = NULL,
  access_secret = NULL
)


<<<<<<< HEAD
#get tweets for Georgia tornado, searched on May 5, 2021
tornado <- search_tweets("tornado OR Atlanta OR mswx OR TXwx", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)

#get tweets without any text filter for the same geographic region in March, searched on May 5, 2021 (what does this accomplish??)
#the query searches for all verified or unverified tweets, so essentially everything
# march <- search_tweets("-filter:verified OR filter:verified", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)

############# FIND ONLY PRECISE GEOGRAPHIES #############

# list unique/distinct place types to check if you got them all
unique(tornado$place_type)

# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding. If you have these, it indicates that you exhausted the more precise tweets in your search parameters
count(tornado, place_type)

#convert GPS coordinates into lat and lng columns
#do not use geo_coords! Lat/Lng will come out inverted
tornado <- lat_lng(tornado,coords=c("coords_coords"))

#select any tweets with lat and lng columns (from GPS) or designated place types of your choosing
tornado <- subset(tornado, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))

#convert bounding boxes into centroids for lat and lng columns
tornado <- lat_lng(tornado,coords=c("bbox_coords"))

# write results of the original twitter search
write.table(tornado$status_id,
            here("data","raw","public","tornadoids.txt"), 
            append=FALSE, quote=FALSE, row.names = FALSE, col.names = FALSE)

############# LOAD SEARCH TWEET RESULTS  ############# 

# load tweet status id's for GA tornado search results
dorianids = 
  data.frame(read.table(here("data","raw","public","dorianids.txt"), 
                        numerals = 'no.loss'))


