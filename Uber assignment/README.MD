# 🚕 Uber Pickups Visualization Dashboard

This Shiny application visualizes Uber pickup data from April to September 2014. It provides interactive tools to explore spatial and temporal patterns in ride data across New York City.

---

## 📦 Features

- **Interactive Heatmap**  
  Visualizes pickup density on a map. Filter by **month**, **day**, and **hour**.

- **Grid Heat Graph**  
  Heatmap of pickup volume across two selected dimensions (e.g., Hour vs Day).

- **Extra Charts**  
  Prebuilt bar plots for deeper time-based analysis.

- **Interactive Tables**  
  Summary tables (pivot and daily) with download buttons.

---

## 📁 Dataset

The app loads and combines six monthly datasets:

```r
files <- c(
  "uber-raw-data-apr14.csv", "uber-raw-data-may14.csv", "uber-raw-data-jun14.csv",
  "uber-raw-data-jul14.csv", "uber-raw-data-aug14.csv", "uber-raw-data-sep14.csv"
)
uber_list <- lapply(files, read.csv)
uber_data <- bind_rows(uber_list)
```

Then, timestamps are processed and extracted:

```r
uber_data <- uber_data %>%
  mutate(
    Date.Time = as.POSIXct(Date.Time, format = "%m/%d/%Y %H:%M:%S"),
    Date = as.Date(Date.Time),
    Time = format(Date.Time, "%H:%M:%S"),
    Day = as.integer(format(Date, "%d")),
    Month = as.integer(format(Date, "%m")),
    Year = as.integer(format(Date, "%Y")),
    Hour = as.integer(substr(Time, 1, 2))
  ) %>%
  select(-Date.Time, -Date)
```

---

## 🖼️ UI Overview

The UI is built using `tabsetPanel()` and organized into four main tabs:

```r
tabsetPanel(
  tabPanel("Heatmap", ...),
  tabPanel("Grid Heat Graph", ...),
  tabPanel("Extra Charts", ...),
  tabPanel("Extra Tables", ...)
)
```

For example, the **color palette dropdown** in the "Grid Heat Graph" is alphabetized:

```r
selectInput("palette", "Select Color Palette:",
            choices = sort(c("C", "D", "A", "B", "E")),
            selected = "C")
```

---

## 🧠 Server Logic

### 1. **Filtering**

All visualizations use filtered data based on user selections:

```r
filtered_data <- reactive({
  data <- uber_data
  if (input$month != "All") data <- data %>% filter(Month == as.numeric(input$month))
  if (input$day != "All") data <- data %>% filter(Day == as.numeric(input$day))
  if (input$hour != "All") data <- data %>% filter(Hour == as.numeric(input$hour))
  data
})
```
### 2. **Leaflet Heatmap**

```r
output$heatmap <- renderLeaflet({
  data <- filtered_data()
  leaflet(data) %>%
    addTiles() %>%
    addHeatmap(lng = ~Lon, lat = ~Lat, blur = 20, max = 0.05, radius = 15)
})
```

### 3. **Grid Heat Plot**

```r
pickup_summary <- data %>%
  group_by(.data[[input$xvar]], .data[[input$yvar]]) %>%
  summarise(Pickups = n(), .groups = 'drop')

ggplot(pickup_summary, aes_string(x = input$xvar, y = input$yvar, fill = "Pickups")) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = input$palette)
```

### 4. **Charts**

Example: Trips per hour across months

```r
ggplot(uber_data, aes(x = Hour, fill = factor(Month))) +
  geom_bar(position = "dodge") +
  scale_fill_viridis_d(name = "Month", option = "C")
```

### 5. **Reactable Tables and Downloads**

```r
output$pivot_table <- renderReactable({
  reactable(filtered_data() %>%
              group_by(Hour) %>%
              summarise(Trips = n(), .groups = 'drop'))
})

output$download_pivot <- downloadHandler(
  filename = function() { "pivot_table.csv" },
  content = function(file) {
    write.csv(filtered_data() %>%
                group_by(Hour) %>%
                summarise(Trips = n()), file, row.names = FALSE)
  }
)
```

---

## ▶️ How to Run

1. Place the Uber CSV files in your working directory (update the `setwd()` path if needed).
2. Open R or RStudio and run the app:

```r
library(shiny)
runApp("app.R")
```

> 💡 Ensure all required packages are installed: `shiny`, `dplyr`, `leaflet`, `ggplot2`, `reactable`, `shinycssloaders`, etc.
