# NLP-Topic-Modelling-and-Sentiment-Analysis-

The study includes the analysis of 10,963 articles of ‘NY Times’ from year 1987 to 2017 which mentions ‘mental health’. The data consists of the features like ‘Title of the Article’, ’Author’, ‘Date’, ’Year’, ‘Text’. As part of the analysis, ‘Year’ and ‘Text of Articles’ has been used to understand the main topics and tone of the articles over the years.

For Factor Analysis, the data was converted to a Document-Term Matrix with the help of MEH tool. Since there are approximately 10,000 articles, it becomes difficult to analyze them all together. So, the data was split into two parts by ‘Year’. For the 20th century analysis, articles from year 1987 to 1999 were considered.3088 articles were analyzed as part of it. For the 21st century analysis, articles from year 2000 to 2017 were considered. 7083 articles were analyzed as part of it. Rows with any missing values are removed.

For Sentiment Analysis, the original data was used with features ‘Year’ and ‘Text’. The pre-processing of the data was done in python. The data was split into two 20th century and 21st century similarly as Factor Analysis.

Analyis
Factor Analyis
Libraries
Loading the required libraries
library(psych)
library(readr)
library(FactoMineR)
library(GPArotation)
library(paran)
# sentiment analysis
library(ggplot2)
library(reticulate)
library(reshape2)
library(viridis)

Data 20th Century
The data has been pre-processed through MEH tool.The output from the MEH tool has been loaded into the R.The data is divided into two parts based on the ‘year’ variables.
setwd("data20century/")

X2020_12_13_MEH_DTM_Verbose<- read_csv("2020-12-13_MEH_DTM_Verbose.csv")
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_double()
## )
## ℹ Use `spec()` for the full column specifications.
data20 <- X2020_12_13_MEH_DTM_Verbose[,-c(2,3,4)]

names(data20)[1] <- "decade"
data20 <- data20[complete.cases(data20), ]
data20$decade <- factor(ifelse(data20$decade<=1999, "20th_Century", "21th_Century"))
Data 21st Century
The data has been pre-processed through MEH tool.The output from the MEH tool has been loaded into the R.
X2020_11_21_MEH_DTM_Verbose <- read_csv("verbose/2020-11-21_MEH_DTM_Verbose.csv")
## Warning: Duplicated column names deduplicated: 'year' => 'year_1' [194]
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_double(),
##   Filename = col_character()
## )
## ℹ Use `spec()` for the full column specifications.
verbose <- X2020_11_21_MEH_DTM_Verbose
verbose <- verbose[complete.cases(verbose), ]
verbose$century <- factor(ifelse(verbose$year>=2000, "21th_Century", "20th_Century"))
table(verbose$century)
## 
## 20th_Century 21th_Century 
##         3880         7083
century <- verbose$century

data21 <- read_csv("newdata21century/data21.csv")
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_double()
## )
## ℹ Use `spec()` for the full column specifications.
data21 <- data21[,-c(2,3,4)]

names(data21)[1] <- "decade"
data21 <- data21[complete.cases(data21), ]

data21$decade <- factor(ifelse(data21$decade>=2000, "21th_Century", "20th_Century"))
