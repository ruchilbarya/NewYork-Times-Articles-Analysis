---
title: 'Understanding Mental Health through 'The New York Times' Articles'
author: "Ruchil Barya"
date: "Sys.Date()"
output: word_document
---
  
  
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set()
```


# Introduction 

New York Times is bestselling newspaper in New York State and read all over the world, it is an important part of today's democrat world by educating and addressing the important issues; But did the paper prioritize the mental health the same way they prioritize other important issues for instance politics? 
  
  In today's world mental health is an important health related issue that needs to be educate and address, because people are virtually connected and spend less time interacting with others outside the digital world leading to depression, stress and anxiety issues.  

The idea of the project was to address mental health by collecting the articles from NYTimes archives and with the help of language modeling understanding the sentiment of how the mental health related issues were addressed over the last three decades? We proposed that over the decades the issues related to mental health has been improved and correctly addressed. 

In a study (Wahl, 2011), 300 articles related to mental health were collected (1998-1999) and analyzed. The results indicated that negative tone of the article reduced slightly in the subsequent year. Another study was conducted collecting 30K NYT articles to explore the topics covered in the articles (Charissa R.,2018). Results suggested that over time, family/home/work-life and sociological trends have taken up a larger share in the total number of articles mentioning 'mental health'.  

Results from a more recent study in the United states (McGinty, 2016) covering 400 random news articles (1995-2014) helped us in understanding the change in topics covered over decades. According to the study, the two most frequently mentioned topics in news coverage about mental illness were violence and suicide. These studies inspired us to investigate more about this topic. 

# Research Question 

As most of the knowledge is gained through news media, it becomes very important to know what news media publish about mental health. It is also helpful to understand if there is a difference in news reporting of such sensitive topic over the years. (Wahl, 2002) 

The goal of this research is to understand how Mental Health has been talked over the years by analyzing 'The New York Times' articles. As part of this analysis, main themes and overall tone of the articles published in 20th century and 21st century is identified. The major differences between 20th century and 21st century articles are also observed.

# Method  

## Data 

The study includes the analysis of 10,963 articles of 'New York Times' from year 1987 to 2017 which mentions 'mental health'. The data consists of the features like 'Title of the Article', 'Author', 'Date', 'Year', 'Text'. As part of the analysis, 'Year' and 'Text' has been used to understand the main topics and tone of the articles over the years. 

For Factor Analysis, the data was converted to a Document-Term Matrix with the help of MEH tool. Since there are approximately 10,000 articles, it becomes difficult to analyze them all together. So, the data was split into two parts by 'Year'. For the 20th century analysis, articles from year 1987 to 1999 were considered.3088 articles were analyzed as part of it. For the 21st century analysis, articles from year 2000 to 2017 were considered. 7083 articles were analyzed as part of it. Rows with any missing values are removed. 

For Sentiment Analysis, the original data was used with features 'Year' and 'Text'. The pre-processing of the data was done in python. The data was split into two 20th century and 21st century similarly as Factor Analysis.

## Method: Factor Analysis

To understand the themes of the articles, Factor analysis was applied. Since our data set was quite large, it was extremely important to use a method which converts the data into smaller and understandable form. Factor Analysis meets these requirements. It decreases several variables to few latent variables and describes group attributes. It finds hidden dimensions. It is efficient in finding the interrelationship between the variables which is needed in our current analysis to find the relationship and differences between 20th and 21st century articles.To decide the number of factors, a scree plot was created with the help of adjusted eigen values, unadjusted eigen values and estimate bias.Non parametric test was used to find the differences with the group

## Method: Sentiment Analysis

For Sentiment Analysis of mental health related articles, the pre-built model from the NLTK package, VADER was used. It takes text as input and returns polarity scores for positive, negative and neutral sentiments. It also provides a compound score which ranges between -1 (extreme negative) and 1 (extreme positive). For this analysis, the compound polarity score was used for understanding tone of the articles over the years. 

VADER model is more suitable for shorter texts like tweets, comments and reviews. After using it to get sentiment scores for large articles, it was observed that the scores were inaccurate and vague. To get best results with this model, each article was divided into sentences using sent_tokenize() method. Polarity scores of these sentences were calculated and the average score was calculated for the entire article. 

The compound polarity score for each year was aggregated (mean score) and label for century (20th /21st Century) was added to create the final scores. 

To understand emotions, NCR lexicon from the R's syuzhet library was used. 5 emotions (anger, fear, sadness, surprise, trust) and 2 sentiments (negative, positive) were focused in the text. The function get_nrc_sentiment() takes the article text and returns valence score for the sentiments and emotions. These scores are aggregated across years to understand the trend. 


# Analyis

## Factor Analyis

### Libraries 
Loading the required libraries

```{r libaries}
library(psych)
library(readr)
library(dplyr)
library(FactoMineR)
library(GPArotation)
library(paran)
```

### Data 20th Century

The data has been pre-processed through MEH tool.The output from the MEH tool has been loaded into the R.The data is divided into two parts based on the 'year' variables.

```{r }

setwd("/home/ruchil_barya/data20century/")

X2020_12_13_MEH_DTM_Verbose<- read_csv("2020-12-13_MEH_DTM_Verbose.csv")

data20 <- X2020_12_13_MEH_DTM_Verbose[,-c(2,3,4)]

names(data20)[1] <- "decade"
data20 <- data20[complete.cases(data20), ]
data20$decade <- factor(ifelse(data20$decade<=1999, "20th_Century", "21th_Century"))

```

### Data 21st Century

The data has been pre-processed through MEH tool.The output from the MEH tool has been loaded into the R.

```{r thedata}

X2020_11_21_MEH_DTM_Verbose <- read_csv("verbose/2020-11-21_MEH_DTM_Verbose.csv")

verbose <- X2020_11_21_MEH_DTM_Verbose
verbose <- verbose[complete.cases(verbose), ]
verbose$century <- factor(ifelse(verbose$year>=2000, "21th_Century", "20th_Century"))
table(verbose$century)
century <- verbose$century

data21 <- read_csv("newdata21century/data21.csv")


data21 <- data21[,-c(2,3,4)]

names(data21)[1] <- "decade"
data21 <- data21[complete.cases(data21), ]

data21$decade <- factor(ifelse(data21$decade>=2000, "21th_Century", "20th_Century"))


```

### Analysis for 20th Century 

The elbow method was used to determine the number of factors .As the scree plot shows, there is a change of slope for n = 5 and 6. We have tried to find the best possibles themes based on these,n=6 showed promising results(themes were interpretable).So, we have used number of factors as 6.

```{r }

paran(data20[,2:1002], iterations = 100, centile = 95)
c1 = principal(data20[,2:1002], nfactors=6, rotate = 'oblimin')
plot(c1$values[1:20])#Select the n values that are reasonable solutions
title("Elbow method for 20th Century")

```


### Themes based on Six factors - Best Solution for 20th Century

Theme1 
Theme 1 talks about that mental illness has been emerged as a problem and solution has to be found for this.

Theme 2
Theme 2 talks about the senate, legislative, bill, election, committee, budget, tax. This theme seems off the topic which talks about bill and elections.

Theme 3
Theme 3 includes many words related to research, psychiatry, medication, treatment, therapy.  This theme is trying to emphasize on the importance of medication and treatment of mentally ill patients, how the mental patients should be treated and how more research can improve their condition.

Theme 4
Theme 4 talks about the homeless, care, shelter, outpatient, community. This theme mainly talks about how the community services can be provided.

Theme 5
Theme 5 includes words like court, lawyer, guilty, murder, justice, death investigate. It is talking about the people who perform crime due to their illness.

Theme 6
Theme 6 talks about the words like medical aid, insurance, facility, finance, hospital, services, coverage which mainly talks about the services, insurance provided by the government for mental health.

```{r solution 1}
#Six factors
loads5 = as.data.frame(c1$loadings[1:1001,1:6])
theme1.20 = subset(loads5[order(loads5$TC1, decreasing = T),], TC1 >= 0.15, select = c(TC1))
theme2.20  = subset(loads5[order(loads5$TC2, decreasing = T),], TC2 >= 0.15, select = c(TC2))
theme3.20  = subset(loads5[order(loads5$TC3, decreasing = T),], TC3 >= 0.15, select = c(TC3))
theme4.20  = subset(loads5[order(loads5$TC4, decreasing = T),], TC4 >= 0.15, select = c(TC4))
theme5.20  = subset(loads5[order(loads5$TC5, decreasing = T),], TC5 >= 0.15, select = c(TC5))
theme6.20  = subset(loads5[order(loads5$TC6, decreasing = T),], TC6 >= 0.15, select = c(TC6))

theme1.20 
theme2.20 
theme3.20 
theme4.20 
theme5.20 
theme6.20 


```

### Statistics (Fit Indices)- 20th Century

The best solution was with number of factors as 6 for 20th century,the statistics are as shown below. Root mean square of residuals is 0.02. It's  lower value is considered as good.So, Root mean square of residuals is good for this model.Root mean squared error of approximation is 0.0156. Its upper confidence interval is 0.0156 and lower confidence interval is 0.0155. It's value is quite small which is good for current model. The tucker lewis index  is 0.24 which is not close to 1. So it can be improved.

```{r}
#Root mean square of the residuals
#The lower the better
fa.stats(data20[,2:1002],f = c1)$rms # for 5 factors

#Root mean squared error of approximation
#Smaller values better
fa.stats(data20[,2:1002],f = c1)$RMSEA # for 5 factors

#tucker lewis index
#Closer to 1 is better

fa.stats(data20[,2:1002],f = c1)$TLI # for 5 factors

```

### Analysis for 21st century 

The elbow method was used to determine the number of factors .As the principal plot shows, there is a change of slope for n = 7. We have tried to find the best possibles themes based on these,n=7 showed promising results(themes were more interpretable ).So, we have used number of factors as 7.

```{r }
paran(data21[,2:1231], iterations = 100, centile = 95)
comp1 = principal(data21[,2:1231], nfactors=5, rotate = 'oblimin')
plot(comp1$values[1:20])#Select the n values that are reasonable solutions
title("Elbow method for 21st Century")
```


### Themes based on Seven factors - Best Solution for 21st Century

Although first two themes does not provide useful information, but all other themes were having most meaningful conclusions which was not possible with other as 5 or 6.
We have used number of factors as 5 and 6 as well but the grouping of variables was best in 7.Themes were most interpretable.

Theme1 and Theme 2
Theme 1 and Theme 2 does not provide any useful information, it has separated the words which do not belong to any themes.

Theme 3
Theme 3 talks about the words like medical aid, insurance, facility, finance, hospital, services, coverage which mainly talks about the services, insurance provided by the government for mental health.

Theme 4
Theme 4 includes many words related to research, psychiatry, medication, treatment, therapy.  This theme is trying to emphasize on the importance of medication and treatment of mentally ill patients, how the mental patients should be treated and how more research can improve their condition.

Theme 5
Theme 5 includes words like court, lawyer, guilty, murder, justice, death investigate. It is talking about the people who perform crime due to their illness.

Theme 6
Theme6 has taken most of the words related to politics, political parties, president. This theme mostly talks about how the government is taking measures to improve mental illness 

Theme 7
Theme 7 includes words like army, stress, suicide, Afghanistan, Iraq, trauma. This theme talks about the veterans, army man how they may be suffering.


```{r solution 2}
#seven factors
comp3 = principal(data21[,2:1231], nfactors=7, rotate = 'oblimin')
loadings7 = as.data.frame(comp3$loadings[1:1230,1:7])
theme1.21 = subset(loadings7[order(loadings7$TC1, decreasing = T),], TC1 >= 0.15, select = c(TC1))
theme2.21 = subset(loadings7[order(loadings7$TC2, decreasing = T),], TC2 >= 0.15, select = c(TC2))
theme3.21 = subset(loadings7[order(loadings7$TC3, decreasing = T),], TC3 >= 0.15, select = c(TC3))
theme4.21 = subset(loadings7[order(loadings7$TC4, decreasing = T),], TC4 >= 0.15, select = c(TC4))
theme5.21 = subset(loadings7[order(loadings7$TC5, decreasing = T),], TC5 >= 0.15, select = c(TC5))
theme6.21 = subset(loadings7[order(loadings7$TC6, decreasing = T),], TC6 >= 0.15, select = c(TC6))
theme7.21 = subset(loadings7[order(loadings7$TC7, decreasing = T),], TC7 >= 0.15, select = c(TC7))

theme1.21
theme2.21
theme3.21
theme4.21
theme5.21
theme6.21
theme7.21

```

### Statistics (Fit Indices)

The best solution was with number of factors as 7 for 21st century,the statistics are as shown below. Root mean square of residuals is 0.02. It's lower value is considered as good.So, Root mean square of residuals is good for this model.Root mean squared error of approximation is 0.0134. It's upper confidence interval is 0.01351 and lower confidence interval is 0.01344. It's value is quite small which is good for current model. The tucker lewis index  is 0.26 which is not close to 1. So it can be improved.


```{r fit indices}
#Root mean square of the residuals
#The lower the better
fa.stats(data21[,2:1231],f = comp3)$rms # for 5 factors

#Root mean squared error of approximation
#Smaller values better
fa.stats(data21[,2:1231],f = comp3)$RMSEA # for 5 factors

#tucker lewis index
#Closer to 1 is better

fa.stats(data21[,2:1231],f = comp3)$TLI # for 5 factors
```



## Group Differences

Null hypothesis: Mental health has been changed in the last 30 years (i.e. There are difference in the articles for 20th and 21st century)

Alternative hypothesis: Mental health has not been changed in the last 30 years (i.e. There are no difference in the articles for 20th and 21st century)

Based on the above hypothesis, the difference between the articles of the 20th and 21st century are interpreted by the non-parametric test .If p value is less 0.05 null hypothesis is true.As per the non-parametric test, Theme 2,4,5,6 for belongs to 20th century all other themes belong to 21st century.

In the 20th century articles, they specifically mentioned about homeless, shelter, community services(theme4.20). In the 20th century articles, Theme 2 talks about the elections, legislation, political agenda but this was not mentioned in 21st century articles. In theme 5 and 6 for 20th century, there is almost same content as 21st century,but the p value is greater than 0.05, there might be minor differences but it was not visible clearly. Theme 7 for 21st century specifically belongs to it as it talks about the soldiers and the causes of their depression.


```{r}

df <- full_join(data20[-1],data21[,-1])
df$century <- century
table(df$century)

df$Theme1.20  = apply(df[,row.names(theme1.20 )], MARGIN = 1, sum)
df$Theme2.20  = apply(df[,row.names(theme2.20 )], MARGIN = 1, sum)
df$Theme3.20  = apply(df[,row.names(theme3.20 )], MARGIN = 1, sum)
df$Theme4.20  = apply(df[,row.names(theme4.20 )], MARGIN = 1, sum)
df$Theme5.20  = apply(df[,row.names(theme5.20 )], MARGIN = 1, sum)
df$Theme6.20  = apply(df[,row.names(theme6.20 )], MARGIN = 1, sum)

df$Theme1.21 = apply(df[,row.names(theme1.21)], MARGIN = 1, sum)
df$Theme2.21 = apply(df[,row.names(theme2.21)], MARGIN = 1, sum)
df$Theme3.21 = apply(df[,row.names(theme3.21)], MARGIN = 1, sum)
df$Theme4.21 = apply(df[,row.names(theme4.21)], MARGIN = 1, sum)
df$Theme5.21 = apply(df[,row.names(theme5.21)], MARGIN = 1, sum)
df$Theme6.21 = apply(df[,row.names(theme5.21)], MARGIN = 1, sum)
df$Theme7.21 = apply(df[,row.names(theme5.21)], MARGIN = 1, sum)

describeBy(df[,c('Theme1.20','Theme2.20','Theme3.20','Theme4.20','Theme5.20','Theme6.20','Theme1.21','Theme2.21','Theme3.21','Theme4.21','Theme5.21','Theme6.21','Theme7.21')], df$century)

wilcox.test(df$Theme1.20~df$century)
wilcox.test(df$Theme2.20~df$century)
wilcox.test(df$Theme3.20~df$century)
wilcox.test(df$Theme4.20~df$century)
wilcox.test(df$Theme5.20~df$century)
wilcox.test(df$Theme6.20~df$century)

wilcox.test(df$Theme1.21~df$century)
wilcox.test(df$Theme2.21~df$century)
wilcox.test(df$Theme3.21~df$century)
wilcox.test(df$Theme4.21~df$century)
wilcox.test(df$Theme5.21~df$century)
wilcox.test(df$Theme6.21~df$century)
wilcox.test(df$Theme7.21~df$century)

```


# Discussion

From the above analysis, we see there are differences in the articles of 20th and 21st century but very few variations are visible. In 20th century articles were mostly based on the medical aid, treatment of mental patients, building hospitals, further research areas, government initiatives to improve the medical services. It also talks about the judiciary system courts, laws, murders, death which specify that convicts suffer depression. Mental illness can be the reason for their misdeeds. These terms are similar to the 21st century articles.These topics are also used in the 21st century articles. The main differences with 20th century articles are, they talk more about politics, community services for homeless, shelter, change in thinking where these topics were not the part of the 21st century articles. The 21st century articles speak about the depression faced by the military soldiers which was not there in 20th century articles. In conclusion, major topics covered in both the articles were same over 30 years with only minor variations. 

# References 

- The Meaning Extraction Helper by Ryan l. Boyd, Ph.D. - Boyd, R.L. (2018). MEH: Meaning Extraction Helper (version 2.1.07) [Software]. Available from https://meh.ryanb.cc 

- Otto E Wahl, Amy Wood & Renee Richards (2002) Newspaper Coverage of Mental Illness: Is It Changing?, Psychiatric Rehabilitation Skills, 6:1, 9-31, DOI: 10.1080/10973430208408417 

- McGinty, E. E., RC, K., PS, W., RG, F., PJ, C., MF, H., . . . Pescosolido, B. A. (2016, June 01). Trends In News Media Coverage Of Mental Illness In The United States: 1995-2014: Health Affairs Journal. Retrieved from https://www.healthaffairs.org/doi/10.1377/hlthaff.2016.0011 

