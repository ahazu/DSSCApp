Coursera Data Science Capstone
========================================================
author: Per M. Rynning
date: 16. September 2016
autosize: true

Pitch for a word prediction application.

Objective
========================================================

For the Data Science Capstone project, Johns Hopkins University has teamed up with
SwiftKey. SwiftKey is well known for creating predictive text applications. 

For my own Capstone project I have built my own predictive text application. 
The application can be found at <https://ahazu.shinyapps.io/Capstone_Project/>


How to use the application
========================================================
![Screenshot of application](presentation-figure/screenshot.PNG)
***
To get started with the application you just need to open the [application](<https://ahazu.shinyapps.io/Capstone_Project/>), place your cursor on the "Input text" field and start typing.

The application is reactive, and will start predicting the following words as soon as text has been written in the field. 


How it works (1/2)
========================================================
The applications [ngram models](https://en.wikipedia.org/wiki/N-gram) are based on data from Twitter, US blogs and News reports. The dataset can be found [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). 
- 70% of the data was processed using the Quanteda and tm R packages to tokenize and clean up the models.
- 4 ngram models were created:
    + Pentagrams (5-grams)
    + Quadgrams (4-grams)
    + Trigrams (3-grams)
    + Bigrams (2-grams)
- To make sure that the performance of the application is good enough, only ngrams of frequency >1 were kept in the final datasets

How it works (2/2)
========================================================
- When performing a prediction the application first searches the 5-gram model, and if it finds no matches (or there are less matches than the requested number of results), the model will *back off* to the 4-grams model using a custom version of "Stupid Backoff"
- The application will back off all the way to the 2-grams model
- The scores on the different models are based on an *alpha value* that can be assigned. This value decides how much weight the lower ngram models should have.

The source code for the application can be found [here](https://github.com/ahazu/DSSCApp)

