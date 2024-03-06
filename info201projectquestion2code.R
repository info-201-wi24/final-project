# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the data from the CSV file
merged_data <- read.csv("merged_data.csv", stringsAsFactors = FALSE)

# Aggregate population and acres burned by year
aggregated_data <- merged_data %>%
  group_by(Year) %>%
  summarise(Total_Population = sum(Estimated.Population, na.rm = TRUE),
            Total_Acres_Burned = sum(AcresBurned, na.rm = TRUE))

# Load necessary libraries
library(ggplot2)



# Line chart with two lines (Acres Burned multiplied by 100 for scaling purposes)
ggplot(aggregated_data, aes(x = Year)) +
  geom_line(aes(y = Total_Population, color = "Population")) +
  geom_line(aes(y = Total_Acres_Burned * 100, color = "Acres Burned (x100)")) +
  labs(title = "Population and Acres (x100 for scaling) Burned by Year",
       x = "Year",
       y = "Count",
       color = "Legend") +
  scale_color_manual(values = c("Population" = "blue", "Acres Burned (x100)" = "red"))