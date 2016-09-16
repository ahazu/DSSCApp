#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Coursera/Swiftkey Capstone Project"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput(inputId = "input_string",
                 label = "Input text",
                 placeholder = "Please type text here"),
       sliderInput(inputId = "num_results",
                   label = "Number of results",
                   min = 1,
                   max = 10,
                   value = 3),
       h4("Filters"),
       checkboxInput(inputId = "swearwords",
                     label = "Filter swearwords",
                     value = FALSE),
       checkboxInput(inputId = "stopwords",
                     label = "Filter stopwords",
                     value = TRUE),
       h4("Advanced Settings"),
       sliderInput(inputId = "alpha",
                   label = "Alpha",
                   value = 0.4,
                   min = 0,
                   max = 1,
                   step = 0.05,
                   round = FALSE),
       checkboxInput(inputId = "showScores",
                     label = "Show Scores",
                     value = FALSE)
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Results", tableOutput("words")),
            tabPanel(title = "Help", 
                     HTML("
                        <h3>About the application</h4>
                        <p>This application is part of the Data Science Specialization Capstone. 
                       You can learn more about the specialization <a href=\"https://www.coursera.org/learn/data-science-project\", target=\"blank\">here</a>
                        <p>Created by Per M. Rynning - <a href=\"mailto:per@rynning.no\">per@rynning.no</a></p>
                          <h3>The basics</h4>
                          <b>Input text</b>: Insert some text here. 
                          When at least one word has been written, the application will return
                          a prediction on what the next word could be.</br></br>
                          Some examples:</br>
                          <i>I hope I win the</i> <u>lottery</u></br>
                          <i>I'll buy a case of</i> <u>beer</u></br>
                          <i>I'll buy my girlfriend a dozen roses for</i> <u>valentine's</u>
                          </br>
                          </br>
                          <b>Number of results</b>: Set the desired number of maximum results you would like to see (1-10)</br>
                          <h3>Filters</h4>
                          <b>Filter swearwords</b>: If checked, the application will not output any swearwords. 
                          The swearwords list was retrieved from <a href=\"https://gist.github.com/MusixmatchHacks/3a4dd893be05093bf277\", target=\"blank\">here</a></br></br>
                          <b>Filter stopwords</b>: If checked, the application will not output any stopwords.
                          Examples of stopwords are: \"i\", \"me\", \"the\", \"to\", etc. You can read more about stopwords
                          <a href=\"https://en.wikipedia.org/wiki/Stop_words\", target=\"blank\">here</a><br/>
                          <h3>Advanced Settings</h4>
                          <b>Alpha</b>: The prediction algorithm uses the <i>alpha</i> when calculating scores for the predictions.
                          This value is used for \"backing off\" when the when combining results from the different ngram tables.</br>
                          </br>An <i>alpha</i> value of 1 will treat all n-1 grams as equal to n-grams, while an <i>alpha</i> value of 0 will treat all n-1 grams as equally worthless.</br></br>
                          <b>Show Scores</b>: If checked the application will show the calculated scores for each of the displayed predictions.
                          The scores are based on word frequencies in the ngram tables and the <i>alpha</i> value.</br>
                          ")
                     )
        )
    )
  )
))
