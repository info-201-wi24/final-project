# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the data from the CSV file
merged_data <- read.csv("merged_data.csv", stringsAsFactors = FALSE)

# Aggregate population and acres burned by year
aggregated_data <- merged_data %>%
  group_by(Year) %>%
  summarise(Total_Acres_Burned = sum(AcresBurned, na.rm = TRUE))

# Line graph showing total acres burned for each year with a trend line
ggplot(aggregated_data, aes(x = Year, y = Total_Acres_Burned)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +  # Add trend line
  labs(title = "Total Acres Burned by Year",
       x = "Year",
       y = "Total Acres Burned")
