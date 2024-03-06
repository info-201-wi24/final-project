library(rsconnect)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(leaflet)
library(sf)
library(stringr)

merged_data <- read.csv("merged_data.csv", stringsAsFactors = FALSE)

aggregated_data <- merged_data %>%
  group_by(Year) %>%
  summarise(Total_Population = sum(Estimated.Population, na.rm = TRUE),
            Total_Acres_Burned = sum(AcresBurned, na.rm = TRUE))

wildfire_data <- read.csv("shiny_ready.csv")
wildfire_data <- wildfire_data %>%
  mutate(County = str_to_title(County),
         County = paste(County, "County"))

counties_shape <- st_read("CA_Counties") %>%
  st_transform(crs = 4326) 

wildfire_data$County <- toupper(gsub(" County", "", trimws(wildfire_data$County)))
counties_shape$NAME <- toupper(gsub(" County", "", trimws(counties_shape$NAME)))
new_county <- counties_shape %>%
  filter(NAME %in% unique(wildfire_data$County))


ui <- dashboardPage(
  dashboardHeader(title = "Deforestation Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Question 1", tabName = "question1"),
      menuItem("Question 2", tabName = "question2"),
      menuItem("Question 3", tabName = "question3"),
      menuItem("Key Takeaways", tabName = "key_takeaways")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              h2("The Importance of Addressing Deforestation"),
              h4("In the relentless dance between progress and nature, deforestation emerges as a formidable adversary, casting a shadow over the environment and the intricate tapestry of our societies. The act of felling trees extends beyond immediate consequences; it triggers a cascade of events that reverberates across humanity. Picture a world where escalating carbon dioxide levels flirt with the atmosphere, pushing climate change to the forefront, disrupting weather patterns, and leaving vulnerable communities in its wake."),
              h4("As the chainsaws echo, indigenous groups find themselves uprooted, not just from their homes, but also from the very roots of their cultural heritage. Deforestation, a juggernaut covering 31% of the Earth's land, demands our immediate attention. It is a crisis etched in the soil, with the complexities of ecosystem damage and the daunting presence of logging businesses making restoration efforts akin to navigating a labyrinth."),
              h4("Yet, within these challenges lies an undeniable truth: a shared responsibility that transcends borders. The urgency to act is our collective call. Are we ready to safeguard our planet, to halt the march of deforestation, and to restore the balance between progress and preservation? Join the movement, be a guardian of our green heritage, and let us rewrite the narrative. Together, we can sow the seeds of change, ensuring a sustainable future where trees stand tall, and cultures thrive in harmony with nature. The time to act is now. Will you heed the call?"),
              img(src = "https://media.istockphoto.com/id/1333314611/photo/massive-california-wild-fire-forcing-thousands-of-people-to-evacuate-their-homes-wildfires.jpg?s=612x612&w=0&k=20&c=BNKmR2g9sXsiXaSsGTtxOvdB_FV0N1bp0jQ1OpCMWMo=")
              ),
      tabItem(tabName = "question1",
              h2("Question 1: Comparing different wildfires counties in California - finding revenue year before and after a fire with at least 1000 acres burned"),
              leafletOutput("map"),
              uiOutput("CountyFireDetails"),
              h4("This is an interactive map that shows each county in California and lists the years it has had a fire that burned more than 1000 acres. This is all taken from our merged_dataset and dataframes made from it. In the case of Question 1, when you select a certain year in each county, it tells you the revenue generated in that county the year before the fire occurred and the year after. This attempts to establish a causal relationship between revenue loss and wildfires in California.")
      ),
      tabItem(tabName = "question2",
              h2("Question 2: Are the fires causing people to move out/less people move in California"),
              fluidRow(
                column(12, selectInput("line_option", "Select Line to Display:", choices = c("Population", "Acres Burned (x100)", "Both"), selected = "Both")),
                column(12, plotOutput("line_chart"))
              ),
              p(""),
              h4("The comparison between population trends and acres burned reveals some similarities, yet lacks a clear correlation. While a decrease in acres burned aligns with a population decline from 2013 to 2014, indicating a positive correlation, the subsequent increase in population despite a decrease in acres burned from 2015 to 2016 suggests a negative correlation. These inconsistencies underscore the absence of a definitive relationship between the datasets, highlighting the complexity of their interaction.")
      ),
      tabItem(tabName = "question3",
              h2("Question 3: Compare wildfire data across California as a whole between 2013 and 2019"),
              fluidRow(
                column(3, checkboxGroupInput("selected_years", "Select years to display:", 
                                             choices = sort(unique(merged_data$Year)), 
                                             selected = sort(unique(merged_data$Year)))),
                column(9, plotOutput("bar_chart")),
                column(12, verbatimTextOutput("analysis_text"))
              ),
              p(""),
              h4("After analyzing the data, it appears that the trend of total acres burned in California generally worsened until 2018, but in 2019, there was a significant decrease. Further investigation revealed that this decrease in 2019 could be attributed to improved preparedness measures. Reports indicate that fire departments acted more swiftly in ordering evacuations and mobilized additional fire crews and aircraft, resulting in a notable decline in the number of acres burned compared to the previous year."),
              
              
      ),
      tabItem(tabName = "key_takeaways",
              h2("Key Takeaways"),
              h4("In this project, we used the California wildfires as an entry point to raise and analyze the following questions:"), 
              h4("Impact of wildfires on local income."),
              h4("Impact of California wildfires on local populations."),
              h4("The area of forest lost each year due to wildfires"),
              p(" --------------- "),
              h4("First, we showed the impact of wildfires on local income through maps. Clicking on the map reveals how severely each county was affected by wildfires (measured by the area of forest burned) and local income before and after the fires. According to statistics, about 22% of fires have caused a loss of local income. Although this figure sounds low, it still proves that wildfires have a negative impact on income. California is the state with the highest economy in the United States, which relies on many high-tech industries during the week. Although only 22% of wildfires caused a loss of revenue, in the remaining cases, the losses caused by wildfires may be masked by high local incomes. This cannot be directly reflected. In other words, because local income is very high, which far exceeds the losses caused by wildfires, it seems from the data that local income is still increasing, but the increase is reduced compared to the case without wildfires. This is a drawback of data, but it is still an issue that cannot be ignored."),
              h4("Next, we also investigated the impact of wildfires on local populations. The chart shows that California's population increases with the severity of wildfires (measured by the area of forest burned). The data shows there is no correlation between California's population and the severity of wildfires. But this is not normal, and we believe the following factors are largely responsible for the changes in California's population. For example, California has better educational resources, more job opportunities, higher incomes, and immigration from both foreign countries and within the United States. These are all important factors that could lead to changes in California's population, and the severity of wildfires pales in comparison."),
              h4("Finally, we summarized the area of forest destroyed by wildfires each year. From 2013 to 2016, the amount of forest destroyed by wildfires remained stable. The area of forest destroyed by wildfires increased dramatically in 2017 and 2018. This is due to factors such as climate change and long-term drought. By 2019, the situation of wildfires has improved, and the area of destroyed forest has been reduced to the lowest level in the figure. This shows that people are aware of the seriousness of wildfires and are making positive changes."),
              img(src = "https://st.depositphotos.com/1000152/1909/i/450/depositphotos_19091863-stock-photo-forest.jpg")
              
      )
    )
  )
)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    leaflet(new_county) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~ifelse(NAME %in% wildfire_data$County, "red", "grey"),
        fillOpacity = 0.8,
        color = "black",
        weight = 1,
        highlightOptions = highlightOptions(weight = 3,
                                            color = "green",
                                            bringToFront = TRUE),
        label = ~NAME,
        layerId = ~NAME) 
    
  })
  
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    
    output$CountyFireDetails <- renderUI({
      
      county_data <- wildfire_data %>%
        filter(tolower(County) == tolower(click$id))
      
      if (nrow(county_data) > 0) {
        tagList(
          h4("Selected County: ", click$id),
          selectInput("chosenFire", "Choose fire",
                      choices = county_data$Year),
          verbatimTextOutput("fireDetails")
        )
      } else {
        h4("No data available for ", click$id)
      }
    })
  })
  output$fireDetails <- renderText({
    req(input$chosenFire)
    if(!is.null(input$chosenFire)) {
      selectedDetails <- wildfire_data %>%
        filter(County == input$map_shape_click$id & Year == input$chosenFire) %>%
        head(1)
      
      if (nrow(selectedDetails) > 0) {
        fire_string <- paste("Info:\n",
                             "Year:", selectedDetails$Year, "\n",
                             "Revenue Before Fire in USD:", selectedDetails$Revenue.Before, "\n",
                             "Revenue After Fire in USD:", selectedDetails$Revenue.After)
        fire_string
      } else {
        "No data available for the selected county and year."
      }
    }
    
  })
  
  
  output$line_chart <- renderPlot({
    aggregated_data_q2 <- aggregated_data
    
    if (input$line_option == "Both") {
      ggplot(aggregated_data_q2, aes(x = Year)) +
        geom_line(aes(y = Total_Population, color = "Population")) +
        geom_line(aes(y = Total_Acres_Burned * 100, color = "Acres Burned (x100)")) +
        labs(title = "Population and Acres (x100 for scaling) Burned by Year",
             x = "Year",
             y = "Count",
             color = "Legend") +
        scale_color_manual(values = c("Population" = "blue", "Acres Burned (x100)" = "red"))
    } else if (input$line_option == "Population") {
      ggplot(aggregated_data_q2, aes(x = Year, y = Total_Population)) +
        geom_line(color = "blue") +
        labs(title = "Population Burned by Year",
             x = "Year",
             y = "Population")
    } else {
      ggplot(aggregated_data_q2, aes(x = Year, y = Total_Acres_Burned * 100)) +
        geom_line(color = "red") +
        labs(title = "Acres Burned (x100) by Year",
             x = "Year",
             y = "Acres Burned (x100)")
    }
  })
  
  output$bar_chart <- renderPlot({
    selected_data <- merged_data %>%
      filter(Year %in% input$selected_years) %>%
      group_by(Year) %>%
      summarise(Total_Acres_Burned = sum(AcresBurned, na.rm = TRUE))
    
    ggplot(selected_data, aes(x = as.factor(Year), y = Total_Acres_Burned)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Total Acres Burned by Year",
           x = "Year",
           y = "Total Acres Burned")
  })
  
  
}

shinyApp(ui = ui, server = server)
