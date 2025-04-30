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
