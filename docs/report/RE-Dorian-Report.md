---
layout: page
title: RE- Spatial-temporal and content analysis of Twitter Data
---


**Replication of**
# Spatial, temporal and content analysis of Twitter data

Original study *by* Wang, Z., X. Ye, and M. H. Tsou. 2016. Spatial, temporal, and content analysis of Twitter for wildfire hazards. *Natural Hazards* 83 (1):523–540. DOI:[10.1007/s11069-016-2329-6](https://doi.org/10.1007/s11069-016-2329-6).
and
First replication study by Holler, J. 2021 (in preparation). Hurricane Dorian vs Sharpie Pen: an empirical test of social amplification of risk on social media.

Replication Author:
Nick Nonnenmacher

Replication Materials Available at: [nicknonnen/RE-Dorian](https://github.com/nicknonnen/RP-Malcomb)

Created: `05 May 2021`
Revised: `10 May 2021`

## Abstract

Why study the spatial distribution of Twitter data?

Wang et al (2016) analyzed Twitter data for wildfires in California, finding that the social media data ...

Holler (2021) is studying Twitter data for Hurricane Dorian on the Atlantic coast, finding that in spite of tending news and social media content regarding a false narrative of risk, original Tweets still clustered significantly along the real hurricane track, and only along the hurricane track.

Reproducing and replicating spatial research of .....  continues to be relevant because ....

In his replication study, I will ...



## Original Study Information

**summarize Wang et al (2016) similar to the Holler (2021) summary below**

Holler (2021) loosely replicated the methods of Wang et al (2016) for the case of Hurricane Dorian's landfall on the U.S. mainland during the 2019 Atlantic Hurricane season. Data was based on Twitter Search API queries for ....

Holler modified Wang et al's methods by not searching for retweets for network analysis, focusing instead on original Tweet content with keywords hurricane, Dorian, or sharpiegate (a trending hashtag referring to the storm). Holler modified the methodology for normalizing tweet data by creating a normalized Tweet difference index and extended teh methodology to test for spatial cluserting with the local Getis-Ord statistic. The study tested a hypothesis that false narratives of hurricane risk promulgated at the highest levels of the United States government would significantly distort the geographic distribution of Twitter activity related to the hurricane and its impacts, finding that original Twitter data still clustered only in the affected areas of the Atlantic coast in spite of false narratives about risk of a westward track through Alabama.

Wang et al (2016) conducted their study using the `tm` and `igraph` packages in `R 3.1.2`. Is it known what GIS software was used for spatial analysis?
The replication study by Holler (2021) used R, including the rtweet, rehydratoR, igraph, sf, and spdep packages for analysis.

## Materials and Procedure

Outline the data to be used in your replication study, including:

- twitter search parameters
- attach / link to files containing status_id's for the search results
- any data used to normalize the tweets
- methods for analysis / synthesis


The data for this lab was procured through a Twitter Developer account, which requires an application but is free of charge. All of our analysis was conducted in RStudio 1.4.1106, and the full code I used to complete this study may be found [here](/dorian/nn_twitter_analysis_search.r).

First, I had to find an event to track. In the early days of May 2021, a minor natural disaster event was unfolding in some southeastern US states, predominantly Mississippi. There is already [a robust Wikipedia article on the event](https://en.wikipedia.org/wiki/Tornado_outbreak_of_May_2–4,_2021), briefly summarizing the geographic location, path, and size of the 82 recorded tornados.

Next, I downloaded appropriate libraries and decided on four search parameters. I used the keyterms 'tornado', 'Atlanta', 'mswx', and 'Txwx', in order to collect a spread of tornado-related tweets in Georgia (where news sources lead me to initially believe the most storm events were - this was later observed to be incorrect, making the 'Atlanta' search term mostly irrelevant), Mississippi ('mswx' is a hashtag indicating Mississippi State Weather Extended tweets), and Texas ('Txwx' is a hashtag indicating Texas Weather Extended tweets, included because many initial 'tornado' tweets also contained this hashtag).

Here, search the Twitter Developer API for the most recent 200,000 tweets with any of your keyterms. This process may take up to two hours.
```
tornado <- search_tweets("tornado OR Atlanta OR mswx OR TXwx", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)
```

Once my tweets were downloaded and imported into R, I started to filter for more precise geographies. Then, I rehydrated those tweets I had selected to access full Tweets. Be sure to examine my [code](/dorian/nn_twitter_analysis_search.r) for a precise report of my workflow.
```
tornado_raw = rehydratoR(twitter_token$app$key, twitter_token$app$secret,
                        twitter_token$credentials$oauth_token,
                        twitter_token$credentials$oauth_secret, tornadoids,
                        base_path = NULL, group_start = 1)
```


## Replication Results

The results of this analysis sought to capture a holistic representation of the rehydrated Twitter data, by visualizing tweet activity in temporal, network, content, and spatial dimensions. For the temporal analysis, we represented tweet activity by hour in Figure 1. The content and network analysis consisted of finding the top 15 most frequently-seen unique words in the poo of tweets, and then creating the word cloud seen in Figure 3, where unique words commonly found together in tweets are linked by lines. The thicker and darker the lines, the more frequent that pair was.

Finally, we joined the tweet data was county geometry data to map Twitter activity by population (Figure 4) and by hotspot clusters (Figure 5). Mapping by population illustrates where the most Twitter activity was occurring, normalized by population, and mapping by hotspot cluster illustrates where abnormally high or low Twitter activity may be found, normalized by the Twitter activity of a temporally distant timeline.

![tweets_per_hour](/assets/tornado_tweetsbyhour.png)
Figure 1. A measure of tweets per hour in the southeastern US, in late April and early May 2021.

![tornado_uniquewordcount](/assets/tornado_uniquewordcount2.png)
Figure 2. Count of unique words in tweets produced in the southeastern US, in late April and early May 2021.

![tornado_wordcloud](/assets/tornado_wordcloud3.png)
Figure 3. A word cloud network of unique words in tweets produced in the southeastern US, in late April and early May 2021.

![tweet_map](/assets/tweetmap1.png)
Figure 4. Visualizing tweet activity by population per county in the southeastern US, in late April and early May 2021.

![clusters_map](/assets/clusters3.png)
Figure 5. Visualizing hot spot clusters where tweets related to the Southeast Tornado event were particularly high or particularly low.


## Unplanned Deviations from the Protocol

Fortunately, this analysis did not suffer any significant unplanned deviations from the replication protocol prepared by Joe Holler in 2019. However, during my initial run-through of this code after debugging and refining code, I realized I had forgotten to include data from a temporally distant timeline with which I could compare tornado-related Twitter activity during early May. To remedy this, I ran another data pull on the morning of May 11th, 2021 (6 days after my initial pull), to access and include any verified and unverified tweets from the same geographic region. I was then able to effectively incorporate this data back into my code using the scaffold provided by Professor Holler and complete my analysis as an accurate replication.  


## Discussion

Provide a summary and interpretation of your key findings in relation to your research question. Mention if findings confirm or contradict patterns observed by Wang et al (2016) or by Holler (2


## Conclusion

Restate the key findings and discuss their broader societal implications or contributions to theory.
Do the research findings suggest a need for any future research?

## References

Include any referenced studies or materials in the [AAG Style of author-date referencing](https://www.tandf.co.uk//journals/authors/style/reference/tf_USChicagoB.pdf).

####  Report Template References & License

This template was developed by Peter Kedron and Joseph Holler with funding support from HEGS-2049837. This template is an adaptation of the ReScience Article Template Developed by N.P Rougier, released under a GPL version 3 license and available here: https://github.com/ReScience/template. Copyright © Nicolas Rougier and coauthors. It also draws inspiration from the pre-registration protocol of the Open Science Framework and the replication studies of Camerer et al. (2016, 2018). See https://osf.io/pfdyw/ and https://osf.io/bzm54/

Camerer, C. F., A. Dreber, E. Forsell, T.-H. Ho, J. Huber, M. Johannesson, M. Kirchler, J. Almenberg, A. Altmejd, T. Chan, E. Heikensten, F. Holzmeister, T. Imai, S. Isaksson, G. Nave, T. Pfeiffer, M. Razen, and H. Wu. 2016. Evaluating replicability of laboratory experiments in economics. Science 351 (6280):1433–1436. https://www.sciencemag.org/lookup/doi/10.1126/science.aaf0918.

Camerer, C. F., A. Dreber, F. Holzmeister, T.-H. Ho, J. Huber, M. Johannesson, M. Kirchler, G. Nave, B. A. Nosek, T. Pfeiffer, A. Altmejd, N. Buttrick, T. Chan, Y. Chen, E. Forsell, A. Gampa, E. Heikensten, L. Hummer, T. Imai, S. Isaksson, D. Manfredi, J. Rose, E.-J. Wagenmakers, and H. Wu. 2018. Evaluating the replicability of social science experiments in Nature and Science between 2010 and 2015. Nature Human Behaviour 2 (9):637–644. http://www.nature.com/articles/s41562-018-0399-z.
