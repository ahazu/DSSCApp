#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)

#Load datasets
load(file = "bigrams_dt")
load(file = "trigrams_dt")
load(file = "quadgrams_dt")
load(file = "pentagrams_dt")

#Set keys and order for performance
setkey(bigrams_dt, word1, word2, Frequency)
setorder(bigrams_dt)

setkey(trigrams_dt, word1, word2, word3, Frequency)
setorder(trigrams_dt)

setkey(quadgrams_dt, word1, word2, word3, word4, Frequency)
setorder(quadgrams_dt)

setkey(pentagrams_dt, word1, word2, word3, word4, word5, Frequency)
setorder(pentagrams_dt)

#Load list of swearwords
sw_con <- file("mxm_profanity_list.txt")
swearwords <- readLines(sw_con)
close(sw_con)

#Source prediction function
source("prediction.R", local = TRUE)

# Shiny server logic to predict next words
shinyServer(function(input, output) {
   
  output$words <- renderTable({
    
    input_string <- input$input_string
    alpha <- input$alpha
    num_results <- input$num_results
    verbose <- input$verbose
    verbosity_level <- input$verbosity_level
    swearwords <- input$swearwords
    remove_stopwords <- input$stopwords
    showScores <- input$showScores
    
    #########################################
 
    Predictions <- predict_word(input_string, 
                                num_results = num_results, 
                                remove_stopwords = remove_stopwords, 
                                remove_swearwords = swearwords,
                                alpha = alpha)
    
    if(input_string == ""){
        Predictions <- c("I predict that you will enter some text", "0")
        names(Predictions) <- c("Predictions", "Score")
    }
    
    if(!showScores)
        Predictions$Score <- NULL
    
    print(as.data.frame(Predictions))
    
  })
  
})
