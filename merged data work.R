library(stringr)
library(ggplot2)
library(dplyr)

county_revenues <- read.csv("/Users/samirdeo/INFO Project 201/Stuff R/County_Revenues_Per_Capita.csv")
fire_incidents <- read.csv("/Users/samirdeo/INFO Project 201/Stuff R/California_Fire_Incidents.csv")

county_revenues <- county_revenues %>%
  mutate(County = str_to_lower(str_trim(`Entity.Name`)), Year = `Fiscal.Year`)


fire_incidents <- fire_incidents %>%
  mutate(County = str_to_lower(str_trim(Counties)), Year = as.integer(format(as.Date(Started, format="%Y-%m-%dT%H:%M:%SZ"), "%Y")))

merged_data <- merge(county_revenues, fire_incidents, by=c("County", "Year"))

merged_data <- merged_data %>%
  select("County", "Year", "Total.Revenues", "Estimated.Population", "Revenues.Per.Capita", "AcresBurned", "StructuresDestroyed")

merged_data <- merged_data %>%
  mutate(AcresBurned = ifelse(is.na(AcresBurnedannsddw)))

output_file_path <- "/Users/samirdeo/INFO Project 201/Stuff R/merged_data.csv"

# Write the merged dataset to a CSV file
write.csv(merged_data, file = output_file_path, row.names = FALSE)
