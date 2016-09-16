#Load libraries
library(tm)
library(stringr)

#Load swearwords
sw_con <- file("mxm_profanity_list.txt")
swearwords <- as.data.table(readLines(sw_con))
close(sw_con)

#Predict words from string
predict_word <- function(input_string, 
                         bigrams_dt, 
                         trigrams_dt, 
                         quadgrams_dt, 
                         num_results = 3,
                         alpha = 0.4,
                         verbose = FALSE,
                         verbosity_level = 5,
                         remove_stopwords = TRUE,
                         remove_swearwords = FALSE){
    
    #Clean up input string
    input_string <- removePunctuation(input_string)
    input_string <- removeNumbers(input_string)
    input_string <- tolower(input_string)
    input_string <- gsub('\\p{So}|\\p{Cn}', '', input_string, perl = TRUE)
    input_string <- gsub('\\s+$', '', input_string, perl = TRUE)
    input_string <- str_split(input_string, " ")
    input_string <- unlist(input_string)
    #input_string <- setdiff(input_string, stopwords("english"))

    
#    if(input_string =="")
#        return("Please enter text")
    
    #Check string lenght
    input_length <- length(input_string)

    #Initializes pentas, quads, tris and bis to help with verbosity++
    pentas <- NULL
    quads <- NULL
    tris <- NULL
    bis <- NULL
    all_matches <- data.frame()
    
    #If there are enough words to calculate a pentagram
    if(input_length >= 4){
        
        #Gets pentagrams
        pentas <- getPentagrams(input_string[(input_length-3):input_length])

        if(!is.null(pentas)){
            names(pentas) <- c("Word", "Score")
            all_matches <- pentas
        }
        if(verbose){
            print("Pentagrams unique matches")
            print(uniqueN(all_matches))
        }
        
        #If unique matches for pentagrams are less than or equal num_results, keep going
        if(uniqueN(all_matches)< num_results){
            #Gets quadgrams that match the inpu
            quads <- getQuadgrams(input_string[(input_length-2):input_length])
            if(!is.null(quads)){
                names(quads) <- c("Word", "Score")
                #Stupid backoff score recalculation
                quads$Score <- quads$Score * alpha
                all_matches <- rbind(all_matches, quads)
            }
            if(verbose){
                print("Penta- and Quadgrams unique matches")
                print(uniqueN(all_matches))
            }
        }
        #If unique matches for penta- and quadgrams <= num_results -> keep going
        if(uniqueN(all_matches)<num_results){
            #Gets the trigrams that match
            tris <- getTrigrams(input_string[(input_length-1):input_length])
            if(!is.null(tris)){
                names(tris) <- c("Word", "Score")
                #Stupid backoff score recalculation
                tris$Score <- tris$Score * alpha * alpha #Alternative way: tris[, Score := Score * alpha * alpha ]
                all_matches <- rbind(all_matches, tris)
            }
            if(verbose){
                print("Penta-, quad- and trigram unique matches")
                print(uniqueN(all_matches))
            }
        }
        #If unique matches for penta-, quad- and trigrams <= num_results -> keep going
        if(uniqueN(all_matches)<num_results){
            #Gets the bigrams that match
            bis <- getBigrams(input_string[input_length])
            if(!is.null(bis)){
                names(bis) <- c("Word", "Score")
                #Stupid backoff score recalculation
                bis$Score <- bis$Score * alpha * alpha * alpha
                all_matches <- rbind(all_matches, bis)
            }
            if(verbose){
                print("Penta-, quad-, tri- and Bigrams unique matches")
                print(uniqueN(all_matches))
            }
        }
        
        
        #Gives a summary of words and scores if verbosity=TRUE
        if(verbose){
            if(!is.null(pentas)){
                print("Pentagram scores:")
                print(head(pentas, n=verbosity_level))}
            if(!is.null(quads)){
                print("Quadgram scores:")
                print(head(quads, n=verbosity_level))}
            if(!is.null(tris)){
                print("Trigram scores:")
                print(head(tris, n=verbosity_level))}
            if(!is.null(bis)){
                print("Bigram scores:")
                print(head(bis, n=verbosity_level))}
        }
        

        setkey(all_matches, Word)
        
        #Removes stopwords
        if(remove_stopwords)
            all_matches <- all_matches[setdiff(Word, stopwords("english")),]
        
        #Remove swearwords
        if(remove_swearwords)
            all_matches <- all_matches[setdiff(Word, swearwords$V1)]

        #Sort by Score
        all_matches <- all_matches[order(all_matches$Score, 
                                         decreasing = TRUE),]
                
        #Returns n_results sorted by score
        return(head(all_matches, n = num_results))
    }
        
    ##################################################
    
    #If there are enough words to calculate a quadgram
    if(input_length >= 3){

        #Gets quadgrams that match the input
        quads <- getQuadgrams(input_string[(input_length-2):input_length])
        
        if(!is.null(quads)){
            names(quads) <- c("Word", "Score")
            all_matches <- quads
        }
        if(verbose){
            print("Quadgrams unique matches")
            print(uniqueN(all_matches))
        }
        
        #If unique matches for and quadgrams <= num_results -> keep going
        if(uniqueN(all_matches)<num_results){
            #Gets the trigrams that match
            tris <- getTrigrams(input_string[(input_length-1):input_length])
            if(!is.null(tris)){
                names(tris) <- c("Word", "Score")
                #Stupid backoff score recalculation
                tris$Score <- tris$Score * alpha
                all_matches <- rbind(all_matches, tris)
            }
            if(verbose){
                print("Penta-, quad- and trigram unique matches")
                print(uniqueN(all_matches))
            }
        }
        #If unique matches for quad- and trigrams <= num_results -> keep going
        if(uniqueN(all_matches)<num_results){
            #Gets the bigrams that match
            bis <- getBigrams(input_string[input_length])
            if(!is.null(bis)){
                names(bis) <- c("Word", "Score")
                #Stupid backoff score recalculation
                bis$Score <- bis$Score * alpha * alpha
                all_matches <- rbind(all_matches, bis)
            }
            if(verbose){
                print("Quad-, tri- and Bigrams unique matches")
                print(uniqueN(all_matches))
            }
        }
        
        #Gives a summary of words and scores if verbosity=TRUE
        if(verbose){
            if(!is.null(quads)){
                print("Quadgram scores:")
                print(head(quads, n=verbosity_level))}
            if(!is.null(tris)){
                print("Trigram scores:")
                print(head(tris, n=verbosity_level))}
            if(!is.null(bis)){
                print("Bigram scores:")
                print(head(bis, n=verbosity_level))}
        }
        

        setkey(all_matches, Word)
        
        #Removes stopwords
        if(remove_stopwords)
            all_matches <- all_matches[setdiff(Word, stopwords("english")),]
        
        #Remove swearwords
        if(remove_swearwords)
            all_matches <- all_matches[setdiff(Word, swearwords$V1)]
        
        #Sort by Score
        all_matches <- all_matches[order(all_matches$Score, 
                                         decreasing = TRUE),]
        
        #Returns n_results sorted by score
        return(head(all_matches, n = num_results))
        
    }
    
    #############################################################
    
    #If there are only enough words to calculate a trigram
    if(input_length >= 2){
        
        #Gets the trigrams that match
        tris <- getTrigrams(input_string[(input_length-1):input_length])
        if(!is.null(tris)){
            names(tris) <- c("Word", "Score")
            all_matches <- tris
        }
        if(verbose){
            print("Trigram unique matches")
            print(uniqueN(all_matches))
        }
        #If unique matches for trigrams <= num_results -> keep going
        if(uniqueN(all_matches)<num_results){
            #Gets the bigrams that match
            bis <- getBigrams(input_string[input_length])
            if(!is.null(bis)){
                names(bis) <- c("Word", "Score")
                #Stupid backoff score recalculation
                bis$Score <- bis$Score * alpha
                all_matches <- rbind(all_matches, bis)
            }
            if(verbose){
                print("Tri- and Bigrams unique matches")
                print(uniqueN(all_matches))
            }
        }
        
        #Stupid backoff scoring for unigrams - TODO
        #tris$Score <- tris$Score
        #bis$Score <- bis$Score * alpha
        
        #Gives a summary of words and scores if verbosity=TRUE
        if(verbose){
            if(!is.null(tris)){
                print("Trigram scores:")
                print(head(tris, n=verbosity_level))}
            if(!is.null(bis)){
                print("Bigram scores:")
                print(head(bis, n=verbosity_level))}
        }
        
        setkey(all_matches, Word)
        
        #Removes stopwords
        if(remove_stopwords)
            all_matches <- all_matches[setdiff(Word, stopwords("english")),]
        
        #Remove swearwords
        if(remove_swearwords)
            all_matches <- all_matches[setdiff(Word, swearwords$V1)]
        
        #Sort by Score
        all_matches <- all_matches[order(all_matches$Score, 
                                         decreasing = TRUE),]
        
        #Returns n_results sorted by score
        return(head(all_matches, n = num_results))
        
    }
    
    #If there are only enough words to calculate a bigram
    if(input_length >= 1){
        #Gets the bigrams that match
        bis <- getBigrams(input_string[input_length])
        if(!is.null(bis)){
            names(bis) <- c("Word", "Score")
            all_matches <- bis
        }
        if(verbose){
            print("Bigrams unique matches")
            print(uniqueN(all_matches))
        }
        
        #Stupid backoff scoring for unigrams - TODO
        #bis$Score <- bis$Score
        
        #Gives a summary of words and scores if verbosity=TRUE
        if(verbose){
            if(!is.null(bis)){
                print("Bigram scores:")
                print(head(bis, n=verbosity_level))}
        }

        
        setkey(all_matches, Word)
        
        #Removes stopwords
        if(remove_stopwords)
            all_matches <- all_matches[setdiff(Word, stopwords("english")),]
        
        #Remove swearwords
        if(remove_swearwords)
            all_matches <- all_matches[setdiff(Word, swearwords$V1)]
        
        #Sort by Score
        all_matches <- all_matches[order(all_matches$Score, 
                                         decreasing = TRUE),]
        
        #Returns n_results sorted by score
        return(head(all_matches, n = num_results))
        
    }
}

#Gets the pentagrams that match with the last 4 words
getPentagrams <- function(search_string){
    matches <- subset(pentagrams_dt, word1 == search_string[1] & word2 == search_string[2] & word3 == search_string[3] & word4 == search_string[4])
    matches <- subset(matches, select=c(word5, Frequency))
    return(matches)
}

#Gets the quadgrams that match with the last 3 words
getQuadgrams <- function(search_string){
    matches <- subset(quadgrams_dt, word1 == search_string[1] & word2 == search_string[2] & word3 == search_string[3])
    matches <- subset(matches, select=c(word4, Frequency))
    return(matches)
}

#Gets the trigrams that match with the last 2 words
getTrigrams <- function(search_string){
    matches <- subset(trigrams_dt, word1 == search_string[1] & word2 == search_string[2])
    matches <- subset(matches, select=c(word3, Frequency))
    return(matches)
}

#Gets the bigrams that match with the last word
getBigrams <- function(search_string){
    matches <- subset(bigrams_dt, word1 == search_string[1])
    matches <- subset(matches, select=c(word2, Frequency))
    return(matches)
}
