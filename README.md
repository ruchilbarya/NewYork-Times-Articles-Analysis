# NLP-Topic-Modelling-and-Sentiment-Analysis-

The study includes the analysis of 10,963 articles of ‘NY Times’ from year 1987 to 2017 which mentions ‘mental health’. The data consists of the features like ‘Title of the Article’, ’Author’, ‘Date’, ’Year’, ‘Text’. As part of the analysis, ‘Year’ and ‘Text of Articles’ has been used to understand the main topics and tone of the articles over the years.

For Factor Analysis, the data was converted to a Document-Term Matrix with the help of MEH tool. Since there are approximately 10,000 articles, it becomes difficult to analyze them all together. So, the data was split into two parts by ‘Year’. For the 20th century analysis, articles from year 1987 to 1999 were considered.3088 articles were analyzed as part of it. For the 21st century analysis, articles from year 2000 to 2017 were considered. 7083 articles were analyzed as part of it. Rows with any missing values are removed.

For Sentiment Analysis, the original data was used with features ‘Year’ and ‘Text’. The pre-processing of the data was done in python. The data was split into two 20th century and 21st century similarly as Factor Analysis.

# Analysis 

## Loading libraries

'''{r}
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
'''{r}
