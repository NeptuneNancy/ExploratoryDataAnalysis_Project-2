## plot6.R --> plot6.png

## Question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
## sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time 
## in motor vehicle emissions?

## Answer: Emissions from motor vehicle sources in Los Angeles are far greater than those found in Baltimore City.
## In addition, emissions in Baltimore City have decreased from 19990-2008, while emmisions in LA increased
## from 1999 - 2005, only decreasing by 2008.  Los Angeles has seen greater changes over time, in both volume
## and direction of change.

## Nancy Gamelin/NeptuneNancy  April 2017

## How I determined "motor vehicle-related sources":
## I inspected the data in the SCC file, and decided the SCC.Level.Two variable contained the pertinant information 
## for searching for vehicle sources of emissions: "Highway Vehicles - Diesel" and 
## "Highway Vehicles - Gasoline" (grep for [Vv]ehicles).  This provided 1137 SCC values. 
## Manually looking over the data in the Short.Name variable confirmed this was a good choice, and included
## light duty vehicles and trucks (gasoline and diesel); heavy duty vehicles and buses (gasoline and diesel); 
## and motorcycles (gasoline). These SCC values were used to extract the emission data from the NEI data frame.

## Once data from only motor vehicle-related sources were identified, the rows pertaining for both 
## Baltimore City and Los Angeles were filtered out.  Each city was done separately until it was
## decided how best to plot the data.  The data was eventually combined into one data frame, with each city
## identified, and this information was used to create the plot to answer the question.



## assume files are in working directory

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## load dplyr if not already loaded

if(!is.element('dplyr', installed.packages()[,1]))
{install.packages('dplyr')
}else {print("dplyr library already installed")}

## load libraries
library(dplyr)

## find info in SCC concerning motor vehicle sources
## SCC,Level.Two has "Highway Vehicles - Diesel" and "-Gasoline" so start there
lvl_2_vehicle_rows <- grep("[Vv]ehicles", SCC$SCC.Level.Two)

## subset SCC to obtain rows concerning vehicles
SCC_vehicles <- SCC[lvl_2_vehicle_rows,]

## use SCC values from SCC_vehicles to subset baltimore df
SCC_values <- SCC_vehicles$SCC

## pull out all rows from NEI concerning motor vehicle emissions

selected_rows <- (NEI$SCC %in% SCC_values)
NEI_vehicles <- NEI[selected_rows,]

## subset to pull out rows concerning motor vehicles in Baltimore City
baltimore <- filter(NEI_vehicles, fips == "24510")

## subset to pull out rows concerning motor vehicles in Baltimore City
los_angeles <- filter(NEI_vehicles, fips == "06037")

## group by year
baltimore_by_years <- group_by(baltimore, year)
los_angeles_by_years <- group_by(los_angeles, year)

balt_df <- summarize(baltimore_by_years, emissions = sum(Emissions, na.rm=TRUE))
la_df <- summarize(los_angeles_by_years, emissions = sum(Emissions, na.rm=TRUE))

## add city column for each df, prior to combining them
balt_mut <- mutate(balt_df, city = "Baltimore")
la_mut <- mutate(la_df, city="Los Angeles")

balt_la <- rbind(balt_mut, la_mut)

## create png of plot

png(filename = "plot6.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 

q <- qplot(year, emissions, data=balt_la, color=city) + geom_line() + labs(x = "Year", y = "Total Emissions (in Tons)", title="Total Emissions - Motor Vehicles")
print(q)

## close device
dev.off()


