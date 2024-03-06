library(dplyr)
library(ggplot2)

# Load the forest conversion data
forest_data <- read.csv("annual-change-forest-area.csv")

# Load the GDP data
gdp_data <- read.csv("Countries GDP 1960-2020.csv")

gdp_data <- subset(gdp_data, select = c("Country.Name", "Country.Code", "X2010"))


forest_data <- forest_data %>% 
  filter(Year == 2010)

# Merge the two datasets by country name
merged_data <- merge(gdp_data, forest_data, by.x = "Country.Name", by.y = "Entity", all.x = TRUE)

# merged_data2 <- merge(forest_data, gdp_data, by.x = "Code", by.y = "Country.Code", all.x = TRUE)


merged_data <- merged_data %>%
  rename(GDP = X2010) %>% 
  na.omit(merged_data) %>% 
  filter(Country.Name != "World") %>% 
  filter(Country.Name != "United States") %>% 
  filter(Country.Name != "China")



ggplot(merged_data, aes(x = GDP, y = `Net.forest.conversion..hectares.`, label = Country.Name)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_text(hjust = 0, vjust = 0.5, size = 3) + 
  labs(x = "GDP", y = "Net Forest Area (hectares)") +
  ggtitle("GDP vs Net Forest Area")

# Top 5 most deforested countries
top_5_most_deforested <- merged_data %>%
  arrange(desc(Net.forest.conversion..hectares.)) %>%
  head(5)

# Least 5 most deforested countries
least_5_most_deforested <- merged_data %>%
  arrange(Net.forest.conversion..hectares.) %>%
  head(5)

# Combine the top 5 most deforested countries and the least 5 most deforested countries
combined_data <- rbind(top_5_most_deforested, least_5_most_deforested)

# Create the chart
ggplot(combined_data, aes(x = reorder(Country.Name, Net.forest.conversion..hectares.), y = Net.forest.conversion..hectares., fill = factor(Country.Name))) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = GDP), vjust = -0.5, size = 3, color = "black") +  # Add labels for GDP
  coord_flip() +
  labs(x = "Country", y = "Net Forest Conversion (hectares)", title = "Top 5 Most and Least Deforested Countries") +
  theme_minimal()

#nrow(merged_data)

#merged_data2 <- na.omit(merged_data2)

#nrow(merged_data2)

#merged_data <- merged_data %>%
  #select(-Country.Name)