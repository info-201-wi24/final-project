library(shiny)
library(shinydashboard)

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
              h2("Question 1: Comparing different wildfires counties in California - find which county is the worst"),
              # Add your chart here
              p("Add your chart here")
      ),
      tabItem(tabName = "question2",
              h2("Question 2: Compare wildfire data to GDP data across the world"),
              # Add your chart here
              p("Add your chart here")
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
  # Add server logic here
}

# Run the application
shinyApp(ui = ui, server = server)
