# Cabbage-Butterfly 🦋

## Contributors 🐛
Chloe Fausett, Bao Tran, Kiet Vu

## Introduction
We will analyze the measurement data of butterflies recorded in different countries to find relationships between the wingspan and location/sex 🦋. <br>
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/26a03df000a8b9125e2a1a673f785fd75c282c55/chart_image/Screen%20Shot%202022-05-15%20at%205.53.05%20PM.png" width = "450")>
</div>
        
## Dictionary 📖
The columns that were used are: 
1. coreid: a unique ID for each butterfly that was recorded.
2. sex: whether the butterfly is male or female.
3. country: where the butterfly is from.
4. year: when the butterfly was recorded.
5. left-wing/right-wing width: the width of the wings in millimeters.
6. left-wing/right-wing length: the length of the wings in millimeters.
7. left-wing/right-wing apex: the measurement from the tip of the wing to the bottom of the wing in millimeters.
8. left-wing/right-wing posterior spot: how far the spot in the bottom wing is from the vein of the wing.
9. left-wing/right-wing anterior spot: how far the spot in the top wing area is from the vein of the wing. 

---
## Data Cleaning 🧹
1. Gender:
- Existing values: Male, Female, F, M, F?, M?, Unknown
- Updated the sex column to reflect male or female. Some data was portrayed as F? or M? so we made a code to just have it formatted to be male or female. If the sex was blank then we made the data say unknown instead.
```
df$SexUpdated[df$SexUpdated == "Female"] <- "female"
df$SexUpdated[df$SexUpdated == "F"] <- "female"
df$SexUpdated[df$SexUpdated == "Male"] <- "male"
df$SexUpdated[df$SexUpdated == "M"] <- "male"
df$SexUpdated[df$SexUpdated == "female?"] <- "unknown"
df$SexUpdated[df$SexUpdated =="male?"] <- "unknown"
df$SexUpdated[is.na(df$SexUpdated)] <- "unknown"
```

2. Location 🌎:
- For the country column, we created a code to make all countries formatted the same.
- For USA there were many different formats, such as U.S.A. and United States, so we formatted it to be United States :us:. 
- There was a blank, so we looked at the locality and formatted the country to represent the locality. The locality said Great Britain, then we said the country was United Kingdom :uk:.
 ```
df$`dwc:country`<- gsub("(?i)USA|(?i)U.S.A.", "United States", df$`dwc:country`)
df$`dwc:country`[is.na(df$`dwc:country`)] <- "United Kingdom"
 ```
 
3. Year 📆: 
- Converted N/A values in year to reflect the YearUpdated column value.
- Fix a record with the YearUpdated value is 200 with the value in the year column.
```
df$YearUpdated[is.na(df$YearUpdated)] <- df$`dwc:year`[is.na(df$YearUpdated)]
df$YearUpdated[df$YearUpdated == 200] <- 2000
```

4. Measurement 📏:
- Measurement = round up to the third decimal. <p>
- Made a code to format the measurements of the wings to reflect the same decimal points. We used the round function to round the measurements to 3 decimal places. Formated all the measurements to reflect number format instead of text format.
```
df$LWingLength <- round(as.numeric(df$LWingLength), digits = 3)
df$LWingWidth <- round(as.numeric(df$LWingWidth), digits = 3)
df$LBlackPatchApex <- round(as.numeric(df$LBlackPatchApex),digits = 3)
df$LAnteriorSpotM3 <- round(as.numeric(df$LAnteriorSpotM3), digits = 3)
df$LPosteriorSpotCu2 <- round(as.numeric(df$LPosteriorSpotCu2), digits = 3)
df$RWingLength <- round(as.numeric(df$RWingLength), digits = 3)
df$RWingWidth <- round(as.numeric(df$RWingWidth), digits = 3)
df$RBlackPatchApex <- round(as.numeric(df$RBlackPatchApex), digits = 3)
df$RAnteriorSpotM3 <- round(as.numeric(df$RAnteriorSpotM3), digits = 3)
df$RPosteriorSpotCu2 <- round(as.numeric(df$RPosteriorSpotCu2), digits = 3)
df$YearUpdated <- as.numeric(df$YearUpdated)
```

5. Get table visible:
- We added code to select the certain columns that we wanted to be visible. 
```
df1 <- df %>%
    dplyr::rename("country" = "dwc:country",
                    "year" = "YearUpdated",
                    "sex" = "SexUpdated") %>%
    dplyr::select("coreid", "sex", "LWingLength", "LWingWidth",
                "LBlackPatchApex", "LAnteriorSpotM3", "LPosteriorSpotCu2",              
                "RWingLength", "RWingWidth", "RBlackPatchApex","RAnteriorSpotM3",           
                "RPosteriorSpotCu2","year", "country")
```
        
6. Drop any record that have 1 N/A value:               
```
df2 <- df1 %>%
    drop_na()
```

7. Sort the data:
We sorted the data by sex then country then year.
```
df_butterfly <- df2 %>%
  arrange(sex, year, country)
```
        
8. Export to CSV file:
```
write.csv(df_butterfly, "/Users/baodinhgiatran/Desktop/DATA 332/cabbage_butterfly-main/clean_data.csv", row.names = FALSE)
```
        
---
## Data Summary

|Country|Year|Female|Male|
|---|:-:|--:|--:|
|Canada|1960s|19|11|
|Canada|1970s|0|1|
|Republic of Ireland|1890s|1|5|
|Republic of Ireland|1900s|0|1|
|Republic of Ireland|1910s|27|15|
|Republic of Ireland|1920s|16|13
|Republic of Ireland|1930s|7|0|
|Republic of Ireland|1970s|2|0|
|United Kingdom|1820s|1|1|
|United Kingdom|1840s|6|3|
|United Kingdom|1850s|1|1|
|United Kingdom|1860s|4|1|
|United Kingdom|1870s|3|2|
|United Kingdom|1880s|16|8|
|United Kingdom|1890s|28|19|
|United Kingdom|1900s|16|13|
|United Kingdom|1910s|27|33|
|United Kingdom|1920s|49|37|
|United Kingdom|1930s|28|19|
|United Kingdom|1940s|19|6|
|United Kingdom|1950s|12|5|
|United Kingdom|1960s|4|5|
|United Kingdom|1970s|13|9|
|United Kingdom|1980s|1|3|
|United Kingdom|1990s|0|1|
|United Kingdom|2010s|7|0|
|United States|1860s|0|1|
|United States|1910s|1|2|
|United States|1920s|4|1|
|United States|1930s|1|5|
|United States|1940s|3|6|
|United States|1950s|11|7|
|United States|1960s|51|57|
|United States|1970s|27|33|
|United States|1980s|6|9|
|United States|1990s|3|3|
|United States|2000s|2|6|
|United States|2010s|3|11|

---
## Data Analysis

1. Number of butterflies recorded by decades:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/183cecb6dbdd8a994492a931371071aea5d24043/chart_image/line_chart_by_decade.png" width = "700")>
</div>
        
* This measurement data has been recorded over the period of almost 2 centuries since 1821.
* The last data point was recorded in 2017.
* The number of recorded fluctuated remarkably between the decades.
* Most of butterflies in this project were recorded in the 20th century, especially in the 1920s and 1960s.
* We think this chart is valuable as it raises a question whether the measurement of this species may change over time and whether our outcome may be subject to certain decades.

2. Number of butterflies recorded by Country and Sex:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/183cecb6dbdd8a994492a931371071aea5d24043/chart_image/bar_chart_by_sex_country.png" width = "600")>
</div>

- The butterflies were measured in 2 continents: Europe and America. In Europe, scientists collected samples in the United Kingdom and Republic of Ireland, while Canada and the United States were their choice of locality in America.
- Among these countries, while the United Kingdom has the largest number of records with about 400 records, Canada has the smallest one with about 30 records.
- As visualized by the chart, the number of records was distributed quite equally for both genders.
- We think this chart is useful because it can illustrate how variable our dataset is and how good our sample is so that we can have a good hypothesis to test the relationship between the measurement and continents.

3. Wingspan size comparison:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/15193dad1d0b8e3a7999cb3ec399526256c22a0d/chart_image/wingspan_compare.png" width = "600")>
</div>
        
- These numbers were calculated by using mean values of each measurement.
- According to the graph, the wingspan size of butterflies from America is bigger than the ones of Europe.
- This finding is critical because it is a foundation for our hypothesis which is the wingspan of cabbage butterflies may be different in different continent.

4. Wingspan size by sex:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/db60d4621dbfdbc176af0c1c732d18ce80a8022f/chart_image/wing_span_by_sex.png" width = "700")>
</div>       

- This graph includes min, median, mean, and max values of each measurement by sex. 
- In the graph, there is no significant difference between size of each sex.
- Like the third graph, this graph is a strong base for us to conduct the t test on wingspan size of each gender to find out if the sex of an butterfly affects the length and the width of its wings.
        
5. T-test on continents:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/9f2e6f6232aa03f2b65288ccf04d4a34d1c76f93/chart_image/ttest1.png" width = "500")>
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/dd3169695c5bea562bf8531bc38f35471795d919/chart_image/ttest2.png" width = "500")>   
</div>      

- Null hypothesis: the wing area of butterflies from Europe is greater than or equal to that of butterflies of America.
- Alternative hypothesis: the wing area of butterflies from Europe is less than that of butterflies of America.
- p-value is much less than alpha = 0.05
- **There is strong evidence that the wing area of butterflies from Europe is less than that of butterflies of America.**

6. T-test on sex:
<div align = "center">
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/511a8fe754cd5dff729961c84f063843640cf121/chart_image/LWL.png" width = "500")>
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/511a8fe754cd5dff729961c84f063843640cf121/chart_image/RWL.png" width = "500")>
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/511a8fe754cd5dff729961c84f063843640cf121/chart_image/LWW.png" width = "500")>
<img src = "https://github.com/team-entomophobia/Cabbage-Butterfly/blob/511a8fe754cd5dff729961c84f063843640cf121/chart_image/RWW.png" width = "500")> 
</div>  

- Null hypothesis: the wing area of male butterflies is equal to that of female butterflies.
- Alternative hypothesis: the wing area of male butterflies is different than that of female butterflies.
- **There is insufficient evidence to conclude that the wing area of male butterflies is different than that of female butterflies.**

---

## Conclusion
1. There is a relationship between the measurement of wings of cabbage butterflies and continents where they live in.
2. There is insufficient evidence to find the relationship between the measurement of wings of cabbage butterflies and their gender.
