install.packages("leaflet")
install.packages("sf")
library(shiny)
library(shinydashboard)
library(leaflet)
library(sf)
library(dplyr)

wildfire_data <- read.csv("/Users/samirdeo/INFO Project 201/Stuff R/shiny_ready.csv")
wildfire_data <- wildfire_data %>%
  mutate(County = str_to_title(County),
         County = paste(County, "County"))

counties_shape <- st_read("/Users/samirdeo/INFO Project 201/Stuff R/CA_Counties") %>%
  st_transform(crs = 4326) 

wildfire_data$County <- toupper(gsub(" County", "", trimws(wildfire_data$County)))
counties_shape$NAME <- toupper(gsub(" County", "", trimws(counties_shape$NAME)))
new_county <- counties_shape %>%
  filter(NAME %in% unique(wildfire_data$County))



# Define UI
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
              h2("The Importance of addressing deforestation"),
              p("In the relentless dance between progress and nature, deforestation emerges as a formidable adversary, casting a shadow over the environment and the intricate tapestry of our societies. The act of felling trees extends beyond immediate consequences; it triggers a cascade of events that reverberates across humanity. Picture a world where escalating carbon dioxide levels flirt with the atmosphere, pushing climate change to the forefront, disrupting weather patterns, and leaving vulnerable communities in its wake."),
              p("As the chainsaws echo, indigenous groups find themselves uprooted, not just from their homes, but also from the very roots of their cultural heritage. Deforestation, a juggernaut covering 31% of the Earth's land, demands our immediate attention. It is a crisis etched in the soil, with the complexities of ecosystem damage and the daunting presence of logging businesses making restoration efforts akin to navigating a labyrinth."),
              p("Yet, within these challenges lies an undeniable truth: a shared responsibility that transcends borders. The urgency to act is our collective call. Are we ready to safeguard our planet, to halt the march of deforestation, and to restore the balance between progress and preservation?"),
              p("Join the movement, be a guardian of our green heritage, and let us rewrite the narrative. Together, we can sow the seeds of change, ensuring a sustainable future where trees stand tall, and cultures thrive in harmony with nature. The time to act is now. Will you heed the call?"),
              img(src = "Info201HomePagePicture.png", width = "100%")
      ),
      tabItem(tabName = "question1",
              h2("Question 1: Comparing different wildfires counties in California - finding revenue year before and after a fire with at least 1000 acres burned"),
              # Add your chart here
              leafletOutput("map"),
              uiOutput("CountyFireDetails")
      ),
      tabItem(tabName = "question2",
              h2("Question 2: Compare wildfire data to GDP data across the world"),
              # Add your chart here
              
      ),
      tabItem(tabName = "question3",
              h2("Question 3: Compare wildfire data across the world over time within past (20) amount of years"),
              # Add your charts here
              p("Add your charts here")
      ),
      tabItem(tabName = "key_takeaways",
              h2("Key Takeaways"),
              p("Summary and Purpose")
      )
    )
  )
)


# Define server logic
server <- function(input, output) {
  
  #new_map <- st_transform(new_map, crs = 4326)
  
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

  
}

# Run the application
shinyApp(ui = ui, server = server)
