# NLP-Topic-Modelling-and-Sentiment-Analysis-
_An Analysis based on Natural Language Processing_

 The goal of this research is to understand how Mental Health has been talked over the years by analyzing The Newyork Times articles. This research includes the analysis of 10,963 articles from year 1987 to 2017 which mentions ‘mental health’. As part of this analysis, main themes and overall tone of the articles published in 20th century and 21st century is identified. 
 
## Results (Major Findings)

There were no major differences observed with respect to the content of articles between 20th century and 21st century.The articles from 1987 to 2017 talks about reserach, treatment, crimes, investigation, politics, which was captured in different themes of the analysis. However, there were some articles in 21st century articles which talks about the soldiers, military,army and the causes of their depression which was not mentioned in the 20th century articles. In terms of the tone of the articles, they are more positive in 21st century.

## Dataset description and methods

This project has four main components: Data Cleaning, Model Creation(Factor Analysis and Sentiment Analysis) and Results.

The data was taken from New york Times articles which mentions ‘mental health’ from year 1987 to 2017. As part of the analysis, ‘Year’ and ‘Text of Articles’ has been used to understand the main topics and tone of the articles over the years.

For Factor Analysis, the data was converted to a Document-Term Matrix with the help of [MEH tool](https://meh.ryanb.cc). Since there are approximately 10,000 articles, it becomes difficult to analyze them all together. So, the data was split into two parts by ‘Year’. For the 20th century analysis, articles from year 1987 to 1999 were considered.3088 articles were analyzed as part of it. For the 21st century analysis, articles from year 2000 to 2017 were considered. 7083 articles were analyzed as part of it. Rows with any missing values are removed.

For Sentiment Analysis, the original data was used with features ‘Year’ and ‘Text’. The pre-processing of the data was done in python. The data was split into two 20th century and 21st century similarly as Factor Analysis.

