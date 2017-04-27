## plot5.R --> plot5.png

## Question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## Answer: Emissions due to motor vehicle sources in Baltimore City have decreased from 1999-2008,
## with the largest decrease occuring from 1999 to 2002.

## Nancy Gamelin/NeptuneNancy  April 2017

## How I determined "motor vehicle-related sources":
## I inspected the data in the SCC file, and decided the SCC.Level.Two variable contained the pertinant information 
## for searching for vehicle sources of emissions: "Highway Vehicles - Diesel" and 
## "Highway Vehicles - Gasoline" (grep for [Vv]ehicles).  This provided 1137 SCC values. 
## Manually looking over the data in the Short.Name variable confirmed this was a good choice, and included
## light duty vehicles and trucks (gasoline and diesel); heavy duty vehicles and buses (gasoline and diesel); 
## and motorcycles (gasoline). These SCC values were used to extract the emission data from the NEI data frame.

## Once data from only motor vehicle-related sources were identified, the rows pertaining only to 
## Baltimore City were filtered out.



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


## interested in total emissions per year in Baltimore City from all motor vehicle sources

## group by year
baltimore_by_years <- group_by(baltimore, year)

plot5_df <- summarize(baltimore_by_years, emissions = sum(Emissions, na.rm=TRUE))

## create png of plot

png(filename = "plot5.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 
with(plot5_df, plot(year, emissions, 
                    xlab = "Year", 
                    ylab = "Total Emissions (in Tons)", 
                    type = "o",
                    pch=19, 
                    xlim = range(1998, 2008), 
                    ylim = range(50, 400)))

title(main = "Total Emissions Per Year - \nMotor Vehicle Sources in Baltimore City" )

## close device
dev.off()
