# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the data from the CSV file
merged_data <- read.csv("merged_data.csv", stringsAsFactors = FALSE)

# Aggregate population and acres burned by year
aggregated_data <- merged_data %>%
  group_by(Year) %>%
  summarise(Total_Acres_Burned = sum(AcresBurned, na.rm = TRUE))

# Bar chart for each year showing total acres burned
ggplot(aggregated_data, aes(x = as.factor(Year), y = Total_Acres_Burned)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Total Acres Burned by Year",
       x = "Year",
       y = "Total Acres Burned")
