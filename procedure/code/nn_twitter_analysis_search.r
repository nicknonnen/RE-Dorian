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
library(tidytext)
library(tm)
library(tidyr)
library(ggraph)
library(tidycensus)
library(ggplot2)
library(RPostgres)
library(RColorBrewer)
library(DBI)
library(rccmisc)
library(here)
library(spdep)
library(sf)
library(tidyverse)

twitter_token = create_token(
  app = "Open Source GIScience",                     #enter your app name in quotes
  consumer_key = "HSF9cPtTb0GOoxO5RO2BYry9k",  		      #enter your consumer key in quotes - this is Kufre's!!!
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

# run the following two lines of code if the data is already downloaded
# load(here("data","derived","private","tornado.RDS"))
tornado <- readRDS(here("data","derived","private","tornado.RDS"))

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
tornadoids = 
  data.frame(read.table(here("data","raw","public","tornadoids.txt"), 
                        numerals = 'no.loss'))

# rehydrate tornado tweets
# rehydration = using Tweet IDs to access full Tweets
tornado_raw = rehydratoR(twitter_token$app$key, twitter_token$app$secret, 
                        twitter_token$credentials$oauth_token, 
                        twitter_token$credentials$oauth_secret, tornadoids, 
                        base_path = NULL, group_start = 1)

############# FILTER DORIAN FOR CREATING PRECISE GEOMETRIES ############# 

# reference for lat_lng function: https://rtweet.info/reference/lat_lng.html
# adds a lat and long field to the data frame, picked out of the fields
# that you indicate in the c() list
# sample function: lat_lng(x, coords = c("coords_coords", "bbox_coords"))

# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding.
# If you have these, it indicates that you exhausted the more precise tweets 
# in your search parameters and are including locations based on user profiles
count(tornado_raw, place_type)

# convert GPS coordinates into lat and lng columns
# do not use geo_coords! Lat/Lng will be inverted
tornado = lat_lng(tornado_raw, coords=c("coords_coords"))

# select any tweets with lat and lng columns (from GPS) or 
# designated place types of your choosing
tornado = subset(tornado, 
                place_type == 'city'| place_type == 'neighborhood'| 
                  place_type == 'poi' | !is.na(lat))

# convert bounding boxes into centroids for lat and lng columns
tornado = lat_lng(tornado,coords=c("bbox_coords"))

# re-check counts of place types
count(tornado, place_type)

############# SAVE FILTERED TWEET IDS TO DATA/DERIVED/PUBLIC ############# 

write.table(tornado$status_id,
            here("data","derived","public","tornadoids.txt"), 
            append=FALSE, quote=FALSE, row.names = FALSE, col.names = FALSE)

############# SAVE TWEETs TO DATA/DERIVED/PRIVATE ############# 

saveRDS(tornado, here("data","derived","private","tornado.RDS"))


############# TEMPORAL ANALYSIS ############# 

#create temporal data frame & graph it

<<<<<<< HEAD
tornadoByHour <- ts_data(tornado, by="hours")
ts_plot(tornado, by="hours")
=======
  tornadoTweetsByHour <- ts_data(tornado, by="hours")
ts_plot(tornado, by="hours")
>>>>>>> 5bfef98f280e66ed25bd44fdb62fed509fa677b9


############# NETWORK ANALYSIS ############# 

<<<<<<< HEAD
#create network data frame. Other options for 'edges' in the network include mention, retweet, and reply
tornadoNetwork <- network_graph(tornado, c("quote"))

plot.igraph(tornadoNetwork)
#Please, this is incredibly ugly... if you finish early return to this function and see if we can modify its parameters to improve aesthetics


############# TEXT / CONTEXTUAL ANALYSIS ############# 

#remove urls, fancy formatting, etc. in other words, clean the text content
tornadoText = tornado %>% select(text) %>% plain_tweets()
=======
  # Create network data frame. 
  # Other options for 'edges' in the network include mention, retweet, and reply
  tornadoNetwork <- network_graph(tornado, c("quote"))

plot.igraph(tornadoNetwork)
# This graph needs serious work... e.g. subset to a single state maybe?


############# TEXT / CONTEXTUAL ANALYSIS PART 2############# 
# do i need both part 1 and part 2?

# remove urls, fancy formatting, etc. in other words, clean the text content
tornadoText = tornado %>% select(text) %>% plain_tweets()
>>>>>>> 5bfef98f280e66ed25bd44fdb62fed509fa677b9

# parse out words from tweet text
tornadoWords = tornadoText %>% unnest_tokens(word, text)

# how many words do you have including the stop words?
count(tornadoWords)
  # n = 142,827

# create list of stop words (useless words not worth analyzing) 
data("stop_words")

# add "t.co" twitter links to the list of stop words
# also add the twitter search terms to the list
stop_words = stop_words %>% 
  add_row(word="t.co",lexicon = "SMART") %>% 
  add_row(word="tornado",lexicon = "Search") %>% 
  add_row(word="Atlanta",lexicon = "Search") %>% 
  add_row(word="mswx",lexicon = "Search") %>% 
  add_row(word="Txwx",lexicon = "Search")

#delete stop words from dorianWords with an anti_join
tornadoWords =  tornadoWords %>% anti_join(stop_words) 

# how many words after removing the stop words?
count(tornadoWords)
  # n = 79,167

# graph frequencies of words
tornadoWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

# separate words and count frequency of word pair occurrence in tweets
tornadoWordPairs = tornadoText %>% 
  mutate(text = removeWords(tolower(text), stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2) %>%
  separate(paired_words, c("word1", "word2"),sep=" ") %>%
  count(word1, word2, sort=TRUE)

# graph a word cloud with space indicating association.
# you may change the filter to filter more or less than pairs with 30 instances
tornadoWordPairs %>%
  filter(n >= 25 & !is.na(word1) & !is.na(word2)) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network of Tweets during Early May 2021 Southeast Tornados",
       x = "", y = "") +
  theme_void()


######## SPATIAL JOIN TWEETS and COUNTIES ######## 
# This code was developed by Joseph Holler, 2021
# This section may not be necessary if you have already spatially joined
# and calculated normalized tweet rates in PostGIS

tornado_sf = tornado %>%
  st_as_sf(coords = c("lng","lat"), crs=4326) %>%  # make point geometries
  st_transform(4269) %>%  # transform to NAD 1983
  st_join(select(counties,GEOID))  # spatially join counties to each tweet

tornado_by_county = tornado_sf %>%
  st_drop_geometry() %>%   # drop geometry / make simple table
  group_by(GEOID) %>%      # group by county using GEOID
  summarise(tornado = n())  # count # of tweets

# DONT RUN THIS BLOCK, RUN NEXT INSTEAD
# counties_tornado = counties_tornado %>%
 #  left_join(tornado_by_county, by="GEOID") %>% # join count of tweets to counties
 #  mutate(tornado = replace_na(tornado,0))       # replace nulls with 0's

counties_tornado <- counties %>%
  left_join(tornado_by_county, by="GEOID") %>% # join count of tweets to counties
  mutate(tornado = replace_na(tornado,0))        # replace nulls with 0's

rm(tornado_by_county)

# save counties geographic data with derived tweet rates
saveRDS(counties_tornado,here("data","derived","public","counties_tornado_tweet_counts.RDS"))


######## SPATIAL CLUSTER ANALYSIS ######## 
# This code was originally developed by Casey Lilley (2019)
# and edited by Joseph Holler (2021)
# See https://caseylilley.github.io/finalproj.html

thresdist_tornado = counties_tornado %>% 
  st_centroid() %>%     # convert polygons to centroid points
  st_coordinates() %>%  # convert to simple x,y coordinates to play with stdep
  dnearneigh(0, 110, longlat = TRUE) %>%  # use geodesic distance of 110km
  # distance should be long enough for every feature to have >= one neighbor
  include.self()       # include a county in its own neighborhood (for G*)

# three optional steps to view results of nearest neighbors analysis
thresdist_tornado # view statistical summary of the nearest neighbors 
  # Neighbour list object:
  # Number of regions: 1705 
  # Number of nonzero links: 48793 
  # Percentage nonzero weights: 1.678451 
  # Average number of links: 28.6176 

plot(counties_tornado, border = 'lightgrey')  # plot counties background
plot(selfdist, coords, add=TRUE, col = 'red') # plot nearest neighbor ties

#Create weight matrix from the neighbor objects
dwm_tornado = nb2listw(thresdist_tornado, zero.policy = T)

