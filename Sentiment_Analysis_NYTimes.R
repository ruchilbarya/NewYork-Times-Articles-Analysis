---
  title: 'Sentiment Analysis'
author: "Ruchil Barya"
date: "`r Sys.Date()`"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Load R the libraries

```{r libaries}
##r chunk
library(dplyr)
library(ggplot2)
library(readr)
library(reticulate)

```

Read csv file in R

```{r}
df = read.csv("NYTMentalHealthArticles.csv")
str(df)

#head(df)
nrow(df)




```

Load Python Libraries

```{python}

#nltk.download('vader_lexicon')
#nltk.download('stopwords', 'punkt', 'wordnet')

import nltk
import warnings
warnings.filterwarnings('ignore')
from nltk.sentiment.vader import SentimentIntensityAnalyzer

import re
import pandas as pd
from nltk.corpus import stopwords
from wordcloud import WordCloud, STOPWORDS
import dateutil.parser as dparser
import spacy

from nltk import tokenize
from datetime import datetime, timedelta
import time
import pprint
from nltk import word_tokenize
from statistics import mean


```

Read file in python

```{python read}

df = r.df
df.head()


```
Converted dates to a standard formatted date type. Removed rows where date fields had characters and string values.

```{python}
df['NewDate'] = pd.to_datetime(df['Date'], errors='coerce')
df = df.dropna(axis=0) 
df[pd.isnull(pd.to_datetime(df.NewDate))]

```
For Sentiment Analysis of mental health related articles, we used the pre-built model from the NLTK package - VADER. It returns a polarity score for positive, negative and neutral sentiments. It also provides a compound score which ranges between -1 (extreme negative) and 1 (extreme positive). For our analysis we used the compound score for understanding sentiment in the articles over the years.

### Method: 

VADER model is more suitable for shorter texts like tweets, comments and reviews. After using it to get sentiment scores for large articles, we observed that the scores were inaccurate and vague. To get best results with this model, each article was divided into sentences using *sent_tokenize* method. Polarity scores of these sentences were calculated and averaged for the entire article.

The compound polarity score for each year was aggregated (mean score) and label for century was added to create the final scores.


```{python}

analyzer = SentimentIntensityAnalyzer()

posts = df['Text']
date_sentiments = {}

# Used VADER with entire article text

#posts = df['Text'].head()
#for post in posts:
#  date = df.loc[df['Text'] == post, 'NewDate'].iloc[0]
#  for sentence in sentence_list:
#    sentiment = analyzer.polarity_scores(post)['compound']
#    date_sentiments.setdefault(date, []).append(sentiment)

for post in posts:
  sentence_list = tokenize.sent_tokenize(post)
date = df.loc[df['Text'] == post, 'NewDate'].iloc[0]

for sentence in sentence_list:
  sentiment = analyzer.polarity_scores(sentence)['compound']
date_sentiments.setdefault(date, []).append(sentiment)

```


```{python}
date_sentiment = {}

for k,v in date_sentiments.items():
  date_sentiment[k.date()] = round(sum(v)/float(len(v)),3)

```


```{python}

sentiments_df = pd.DataFrame(list(date_sentiment.items()),columns = ['Date','Score']) 
sentiments_df.to_csv('sentiment_scores.csv',index=False)

```


```{r}

sentiment_scores = read_csv("sentiment_scores.csv")

#head(sentiment_scores)
sentiment_scores$Year = as.numeric(format(sentiment_scores$Date,'%Y'))

sentiment_scores_year = sentiment_scores %>%
  group_by(Year) %>%
  summarise(mean_score = round(mean(Score),3))

sentiment_scores_year$decade <- factor(ifelse(sentiment_scores_year$Year<=1999, "20th Century", "21th Century"))

# normalized, weighted composite score
head(sentiment_scores_year)

```

Plotting the average compound polarity score for each year, we can observe that in the 20th Century, mental health was discussed in the news articles with a more negative sentiment. We can observe some peaks during the middle of the century, however by year 2000, most articles had an extreme negative sentiment.

The score went extreme low around year 2008. However we see a distinctive rise in the positive sentiment in the later half of the 21st century. Awareness around the subject of mental health has increased and news paper articles are talking about this topic with a more positive sentiment since the last 5 years.


```{r}

# Multiple line plot
ggplot(sentiment_scores_year, aes(x = Year, y = mean_score)) + 
  geom_line(aes(color = decade), size = 1) +
  scale_color_manual(values = c("#00AFBB", "#E7B800")) +
  theme_minimal()

```

```{python}

df.to_csv('updated_dataframe.csv',index=False)

```


To understand emotions, NCR lexicon from the syuzhet package was used. We focused on 5 emotions (anger, fear, sadness, surprise, trust) and 2 sentiments (negative, positive)  in the text. The function *get_nrc_sentiment* takes the article text and returns valence score for the sentiments and emotions. These scores are aggregated across years for further analysis.

```{r}
library(syuzhet)

df = read_csv("updated_dataframe.csv")

nrc = get_nrc_sentiment(df$Text, language = "english")

nrcdf = cbind(df,nrc)

head(nrcdf)

nrcdf$Year = as.numeric(format(nrcdf$NewDate,'%Y'))

# emotions: anger, anticipation, disgust, fear, joy, sadness, surprise, trust, negative

nrc_scores_year = nrcdf %>%
  group_by(Year) %>%
  summarise(mean_anger = round(mean(anger),3),
            #mean_anticipation = round(mean(anticipation),3),
            #mean_disgust = round(mean(disgust),3),
            mean_fear = round(mean(fear),3),
            #mean_joy = round(mean(joy),3),
            mean_sadness = round(mean(sadness),3),
            mean_surprise = round(mean(surprise),3),
            mean_trust = round(mean(trust),3),
            mean_negative = round(mean(negative),3),
            mean_positive = round(mean(positive),3))

nrc_scores_year$decade <- factor(ifelse(nrc_scores_year$Year<=1999, "20th Century", "21th Century"))

head(nrc_scores_year)

```

The plot below represents the average valence scores of articles aggregated over years. The colors represent the emotions. We can observe that the emotions fear and sadness were high in the 20th century and became declining towards the end of 21st century.

```{r}

library(reshape2)
library(viridis)



melted_df=melt(nrc_scores_year,id.vars=c("Year","decade"))
head(melted_df)

# Multiple line plot
ggplot(melted_df, aes(x = Year, y = value)) + 
  geom_line(aes(color = variable), size = 1) +
  scale_color_manual(values = c('#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0')) +
  theme_minimal()

```
