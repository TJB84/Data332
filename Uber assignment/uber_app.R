# Libraries
library(shiny)
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(ggplot2)
library(tidyr)
library(DT)
library(shinycssloaders)
library(reactable)

# Set working directory
setwd("C:/Data/Uber")

# Load and prepare data
files <- c(
  "uber-raw-data-apr14.csv",
  "uber-raw-data-may14.csv",
  "uber-raw-data-jun14.csv",
  "uber-raw-data-jul14.csv",
  "uber-raw-data-aug14.csv",
  "uber-raw-data-sep14.csv"
)

uber_list <- lapply(files, read.csv)
uber_data <- bind_rows(uber_list)

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

# UI
ui <- fluidPage(
  titlePanel("🚕 Uber Pickups Visualization Dashboard"),
  
  tabsetPanel(
    
    tabPanel("Heatmap",
             sidebarLayout(
               sidebarPanel(
                 selectInput("month", "Select Month:", choices = c("All", sort(unique(uber_data$Month)))),
                 selectInput("day", "Select Day:", choices = c("All", sort(unique(uber_data$Day)))),
                 selectInput("hour", "Select Hour:", choices = c("All", sort(unique(uber_data$Hour))))
               ),
               mainPanel(
                 withSpinner(leafletOutput("heatmap", height = 600))
               )
             )
    ),
    
    tabPanel("Grid Heat Graph",
             sidebarLayout(
               sidebarPanel(
                 selectInput("xvar", "Select X-axis:", choices = c("Base", "Day", "Month", "Hour"), selected = "Hour"),
                 selectInput("yvar", "Select Y-axis:", choices = c("Base", "Day", "Month", "Hour"), selected = "Day"),
                 selectInput("palette", "Select Color Palette:", 
                             choices = sort(c("C", "D", "A", "B", "E")), 
                             selected = "C")
               ),
               mainPanel(
                 withSpinner(plotOutput("gridheat", height = 600))
               )
             )
    ),
    
    tabPanel("Extra Charts",
             fluidRow(
               column(6, withSpinner(plotOutput("chart_hour_month", height = 400))),
               column(6, withSpinner(plotOutput("chart_hour", height = 400)))
             ),
             fluidRow(
               column(6, withSpinner(plotOutput("chart_day_month", height = 400))),
               column(6, withSpinner(plotOutput("chart_month", height = 400)))
             ),
             fluidRow(
               column(12, withSpinner(plotOutput("chart_base_month", height = 400)))
             )
    ),
    
    tabPanel("Extra Tables",
             sidebarLayout(
               sidebarPanel(
                 downloadButton("download_pivot", "Download Pivot Table"),
                 br(), br(),
                 downloadButton("download_daily", "Download Daily Trips Table")
               ),
               mainPanel(
                 fluidRow(
                   column(6, h3("Trips by Hour (Pivot Table)"), reactableOutput("pivot_table")),
                   column(6, h3("Trips Every Day"), reactableOutput("daily_trips_table"))
                 )
               )
             )
    )
    
  )
)

# Server
server <- function(input, output, session) {
  
  withProgress(message = 'Loading Data...', value = 0.5, {
    Sys.sleep(1)
  })
  
  # Reactive filtered data
  filtered_data <- reactive({
    data <- uber_data
    if (input$month != "All") data <- data %>% filter(Month == as.numeric(input$month))
    if (input$day != "All") data <- data %>% filter(Day == as.numeric(input$day))
    if (input$hour != "All") data <- data %>% filter(Hour == as.numeric(input$hour))
    data
  })
  
  # Heatmap
  output$heatmap <- renderLeaflet({
    data <- filtered_data()
    
    leaflet(data) %>%
      addTiles() %>%
      addHeatmap(lng = ~Lon, lat = ~Lat, blur = 20, max = 0.05, radius = 15)
  })
  
  # Grid Heatmap
  output$gridheat <- renderPlot({
    data <- filtered_data()
    
    if (input$xvar == "Month") {
      data$Month <- factor(month.name[data$Month], levels = month.name)
    }
    if (input$yvar == "Month") {
      data$Month <- factor(month.name[data$Month], levels = month.name)
    }
    
    pickup_summary <- data %>%
      group_by(.data[[input$xvar]], .data[[input$yvar]]) %>%
      summarise(Pickups = n(), .groups = 'drop')
    
    ggplot(pickup_summary, aes_string(x = input$xvar, y = input$yvar, fill = "Pickups")) +
      geom_tile(color = "white") +
      scale_fill_viridis_c(option = input$palette) +
      labs(
        title = paste("Pickups by", input$xvar, "and", input$yvar),
        x = input$xvar,
        y = input$yvar,
        fill = "Pickups"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Extra Charts
  output$chart_hour_month <- renderPlot({
    ggplot(uber_data, aes(x = Hour, fill = factor(Month))) +
      geom_bar(position = "dodge") +
      scale_fill_viridis_d(name = "Month", option = "C") +
      labs(title = "Trips by Hour and Month", x = "Hour", y = "Number of Trips") +
      theme_minimal()
  })
  
  output$chart_hour <- renderPlot({
    ggplot(uber_data, aes(x = Hour)) +
      geom_bar(fill = "steelblue") +
      labs(title = "Trips Every Hour", x = "Hour", y = "Number of Trips") +
      theme_minimal()
  })
  
  output$chart_day_month <- renderPlot({
    # Create DayOfWeek as a factor with correct order
    uber_data$DayOfWeek <- weekdays(as.Date(paste(uber_data$Year, uber_data$Month, uber_data$Day, sep = "-")))
    uber_data$DayOfWeek <- factor(uber_data$DayOfWeek, 
                                  levels = c("Sunday", "Monday", "Tuesday", "Wednesday", 
                                             "Thursday", "Friday", "Saturday"))
    
    ggplot(uber_data, aes(x = DayOfWeek, fill = factor(Month))) +
      geom_bar(position = "dodge") +
      scale_fill_viridis_d(name = "Month", option = "C") +
      labs(title = "Trips by Day of Week and Month", x = "Day of Week", y = "Number of Trips") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  
  output$chart_month <- renderPlot({
    ggplot(uber_data, aes(x = factor(Month, levels = 1:12, labels = month.name))) +
      geom_bar(fill = "darkgreen") +
      labs(title = "Trips by Month", x = "Month", y = "Number of Trips") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$chart_base_month <- renderPlot({
    ggplot(uber_data, aes(x = Base, fill = factor(Month))) +
      geom_bar(position = "dodge") +
      scale_fill_viridis_d(name = "Month", option = "C") +
      labs(title = "Trips by Base and Month", x = "Base", y = "Number of Trips") +
      theme_minimal()
  })
  
  # Pivot Table
  output$pivot_table <- renderReactable({
    reactable(filtered_data() %>%
                group_by(Hour) %>%
                summarise(Trips = n(), .groups = 'drop'),
              searchable = TRUE, highlight = TRUE, pagination = TRUE)
  })
  
  # Daily Trips Table
  output$daily_trips_table <- renderReactable({
    reactable(filtered_data() %>%
                group_by(Day) %>%
                summarise(Trips = n(), .groups = 'drop'),
              searchable = TRUE, highlight = TRUE, pagination = TRUE)
  })
  
  # Downloads
  output$download_pivot <- downloadHandler(
    filename = function() { "pivot_table.csv" },
    content = function(file) {
      write.csv(filtered_data() %>%
                  group_by(Hour) %>%
                  summarise(Trips = n(), .groups = 'drop'), file, row.names = FALSE)
    }
  )
  
  output$download_daily <- downloadHandler(
    filename = function() { "daily_trips_table.csv" },
    content = function(file) {
      write.csv(filtered_data() %>%
                  group_by(Day) %>%
                  summarise(Trips = n(), .groups = 'drop'), file, row.names = FALSE)
    }
  )
  
}

# Run the app
shinyApp(ui = ui, server = server)
