# Jane Austen Text Analysis

## Introduction
We will analyze the sentiment in the works of Jane Austen using databases give to us in R studio. <br>
<div align = "center">
<img src = "https://github.com/TJB84/Data332/blob/main/sentiment_analysis/text_analysis/download.webp" width = "450")>
</div>
        
## Dictionary 📖
The columns that were used are: 
1. book: a unique ID for each book that was recorded.
2. index: line number for tidy purposes.
3. method: what lexicon was used.
4. n: count.
5. sentiment: a numerical value given to a word by a lexicon
6. positive: total positive sentiment in one line
7. negative: total negative sentiment in one line
8. sentiment: the total sentiment when combineng positive and negative
9. word: the word being described in a chart
10. chapter: the chapter the word appears in
11. line number: the line number of the page the word appears in
    

    
## Data Cleaning 🧹
tidy_books <- austen_books() %>%
  group_by(book) %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text, 
                                regex("^chapter [\\divxlc]", 
                                      ignore_case = TRUE)))) %>%
  ungroup() %>%
  unnest_tokens(word, text)

---
## Data Analysis

1. The sentiment of each of Jane Austen's books as calculated using BING:
<div align = "center">
<img src = "https://github.com/TJB84/Data332/blob/main/sentiment_analysis/text_analysis/allchart.png" width = "700")>
</div>
        
- Persuision seems to be the novel with the most postive vocabulary as many of the indexies are not negatives.
- Mansfield Park seems to be the most varried with other books achiving both higher and lower indivual indexcies score it has more variety in positive and negative sentiment.
- Pride and Prejudices shows to have the most ammount of negative indexcies.

2. The sentiment of Pride and Prejudice across three lexicons:
<div align = "center">
<img src = "https://github.com/TJB84/Data332/blob/main/sentiment_analysis/text_analysis/ppchart.png" width = "600")>
</div>

- BING and AFINN have a drop in sentiment towards the end but NRC does not this shows a difference in how the first two lexicons and the third calculate these sections differently.
- BING gives a large drop in one key section shortly after index 100. this big dip is not shown in th other graphs
- BING has a wider range compared to the others where bing goes from -20 to 40 this allows for a more diverse set of values.

3. Graph of words that contribute to positive and negative sentiment in the books of Jane Austen:
<div align = "center">
<img src = "https://github.com/TJB84/Data332/blob/main/sentiment_analysis/text_analysis/sentiments.png" width = "600")>
</div>
        
- Miss is the main contributor of negative sentiment.
- Well and Good are the main contributors of positive sentiment
- without miss there is not a lot of negative sentiment

4. Word cloud of words most commonly used in Jane Austen's books
<div align = "center">
<img src = "https://github.com/TJB84/Data332/blob/main/sentiment_analysis/text_analysis/wordcloud.png" width = "700")>
</div>       

- Time is one of the words used the most in Austen's books. 
- In the cloud, day and lady are also big words implying they are used often aswell.
- minute is one of the smaller words which is odd since two of the thre biger words deal in the chronological space
        

---

## Conclusion
1. There is a higher ammount of negative sentiment across the words used in her books.
2. this wierdly high sentiment is probably due to the exstensive use of the word miss.
