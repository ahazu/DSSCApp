library(tm)
library(quanteda)
library(data.table)
library(stringr)

#Make connection to files
us_tw_con <- file("en_US.twitter.txt", "r")
us_news_con <- file("en_us.news.txt", "r")
us_blogs_con <- file("en_US.blogs.txt", "r")

#Read all lines
us_twitter <- readLines(us_tw_con, skipNul=TRUE,encoding="UTF-8")
us_news <- readLines(us_news_con, skipNul=TRUE,encoding="UTF-8")
us_blogs <- readLines(us_blogs_con, skipNul=TRUE,encoding="UTF-8")

#Close file connections
close(us_tw_con)
close(us_news_con)
close(us_blogs_con)

#Seed for reproducibility
set.seed(123)

#Take a sample of each dataset (x%)
twitter_samp <- sample(us_twitter, length(us_twitter) * 0.05, replace=FALSE)
news_samp <- sample(us_news, length(us_news) * 0.05, replace=FALSE)
blogs_samp <- sample(us_blogs, length(us_blogs) * 0.05, replace=FALSE)

#Remove datasets with all lines to free memory
rm(us_twitter)
rm(us_news)
rm(us_blogs)

#Remove unwanted characters
#twitter_samp <- gsub('\\p{So}|\\p{Cn}', '', twitter_samp, perl = TRUE)
#news_samp <- gsub('\\p{So}|\\p{Cn}', '', news_samp, perl = TRUE)
#blogs_samp <- gsub('\\p{So}|\\p{Cn}', '', blogs_samp, perl = TRUE)

#Consolidating the datasets
twitter_corp <- corpus(twitter_samp)
news_corp <- corpus(news_samp)
blogs_corp <- corpus(blogs_samp)
all_corp <- twitter_corp + news_corp + blogs_corp

#Creating ngrams
unigrams <- dfm(all_corp,
                ngrams = 1, 
                removeURL = T,
                removeTwitter = T,
                removeNumbers = T, 
                #ignoredFeatures = stopwords("english"),
                removePunct = T,
                removeSeparators = T)

#Creating data frames for easier work
unigrams_df <- data.frame(Words = features(unigrams), 
                          Frequency = colSums(unigrams), 
                          row.names = NULL, 
                          stringsAsFactors = FALSE)

unigrams_dt <- data.table(Frequency = colSums(unigrams),
                          Words = features(unigrams), 
                          row.names = NULL, 
                          stringsAsFactors = FALSE)

########################## BIGRAMS ##########################

bigrams <- dfm(all_corp,
               ngrams = 2, 
               removeURL = T,
               removeTwitter = T,
               removeNumbers = T, 
               #ignoredFeatures = stopwords("english"),
               removePunct = T,
               removeSeparators = T)

#Creating data frames for easier work
bigrams_df <- data.frame(Words = features(bigrams), 
                         Frequency = colSums(bigrams), 
                         row.names = NULL, 
                         stringsAsFactors = FALSE)

#Converts to data table
bigrams_dt <- as.data.table(bigrams_df)

#Remove data frame to free memory
rm(bigrams_df)

#Remove entries with only 1 hit to make dataset easier to export/import
bigrams_dt <- bigrams_dt[Frequency > 1]

#Splits Words into different columns
bigrams_dt[, c("word1", 
               "word2") := 
               as.data.table(str_split_fixed(bigrams_dt$Words, 
                                             "_",
                                             2))]

#Remove Words field to make table smaller
bigrams_dt$Words <- NULL

# Sets keys and order to speed up searches
setkey(bigrams_dt, word1, word2, Frequency)
setorder(bigrams_dt)

#Save data objects
save(bigrams_dt, file="bigrams_dt")



########################## TRIGRAMS ##########################


trigrams <- dfm(all_corp,
                ngrams = 3, 
                removeURL = T,
                removeTwitter = T,
                removeNumbers = T, 
                #ignoredFeatures = stopwords("english"),
                removePunct = T,
                removeSeparators = T)

#Creating data frames for easier work
trigrams_df <- data.frame(Words = features(trigrams), 
                          Frequency = colSums(trigrams), 
                          row.names = NULL, 
                          stringsAsFactors = FALSE)

#Converts to data table
trigrams_dt <- as.data.table(trigrams_df)
rm(trigrams_df)

#Remove entries with only 1 hit to make dataset easier to export/import
trigrams_dt <- trigrams_dt[Frequency > 1]

#Splits Words into different columns
trigrams_dt[, c("word1", 
                "word2",
                "word3") := 
                as.data.table(str_split_fixed(trigrams_dt$Words, 
                                              "_",
                                              3))]

#Remove Words field to make table smaller
trigrams_dt$Words <- NULL

# Sets keys and order to speed up searches
setkey(trigrams_dt, word1, word2, word3, Frequency)
setorder(trigrams_dt)

#Save data objects
save(trigrams_dt, file="trigrams_dt")

########################## QUADGRAMS ##########################

quadgrams <- dfm(all_corp,
                 ngrams = 4, 
                 removeURL = T,
                 removeTwitter = T,
                 removeNumbers = T, 
                 #ignoredFeatures = stopwords("english"),
                 removePunct = T,
                 removeSeparators = T)

#Creating data frames for easier work
quadgrams_df <- data.frame(Words = features(quadgrams), 
                           Frequency = colSums(quadgrams), 
                           row.names = NULL, 
                           stringsAsFactors = FALSE)

#Converts to data table
quadgrams_dt <- as.data.table(quadgrams_df)
rm(quadgrams_df)

#Remove entries with only 1 hit to make dataset easier to export/import
quadgrams_dt <- quadgrams_dt[Frequency > 1]

#Splits Words into different columns
quadgrams_dt[, c("word1", 
                 "word2",
                 "word3",
                 "word4") := 
                 as.data.table(str_split_fixed(quadgrams_dt$Words, 
                                               "_",
                                               4))]

#Remove Words field to make table smaller
quadgrams_dt$Words <- NULL

# Sets keys and order to speed up searches
setkey(quadgrams_dt, word1, word2, word3, word4, Frequency)
setorder(quadgrams_dt)

#Save data objects
save(quadgrams_dt, file="quadgrams_dt")

########################## PENTAGRAMS ##########################

pentagrams <- dfm(all_corp,
                 ngrams = 5, 
                 removeURL = T,
                 removeTwitter = T,
                 removeNumbers = T, 
                 #ignoredFeatures = stopwords("english"),
                 removePunct = T,
                 removeSeparators = T)

#Creating data frames for easier work
pentagrams_df <- data.frame(Words = features(pentagrams), 
                            Frequency = colSums(pentagrams), 
                            row.names = NULL, 
                            stringsAsFactors = FALSE)

#Converts to data table
pentagrams_dt <- as.data.table(pentagrams_df)
rm(pentagrams_df)

#Remove entries with only 1 hit to make dataset easier to export/import
pentagrams_dt <- pentagrams_dt[Frequency > 1]

#Splits Words into different columns
pentagrams_dt[, c("word1", 
                  "word2",
                  "word3",
                  "word4",
                  "word5") := 
                  as.data.table(str_split_fixed(pentagrams_dt$Words, 
                                                "_",
                                                5))]
#Remove Words field to make table smaller
pentagrams_dt$Words <- NULL

# Sets keys and order to speed up searches
setkey(pentagrams_dt, word1, word2, word3, word4, word5, Frequency)
setorder(pentagrams_dt)

#Save data objects
save(pentagrams_dt, file="pentagrams_dt")
