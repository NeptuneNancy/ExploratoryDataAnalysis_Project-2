## plot3.R --> plot3.png

## Question: Of the four types of sources indicated by the 'type' (point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
## Which have seen increases in emissions from 1999-2008?  Use the ggplot2 plotting system to make a plot
## to answer this question.

## Answer:  Of the four types of sources of emissions data in Baltimore City, three have seen steady decreases 
## from 1999 to 2008: on road, non road and non point.  Point sources showed an increase from 1999 to
## 2005, but decreased by 2008, almost to 1999 levels.

## assume files are in working directory
## setwd("~/Desktop/04 Exploratory Analysis/Week 4/Project 2/exdata-data-NEI_data")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## load dplyr if not already loaded

if(!is.element('dplyr', installed.packages()[,1]))
{install.packages('dplyr')
}else {print("dplyr library already installed")}

## load libraries
library(dplyr)

## load ggplot2 if not already loaded
if(!is.element('ggplot2', installed.packages()[,1]))
{install.packages('ggplot2')
}else {print("ggplot2 library already installed")}

## load libraries
library(dplyr)
library(ggplot2)

## extract data for Baltimore City, fips = "24510"
baltimore <- filter(NEI, fips == "24510")


## group by year and type
balt_year_type <- group_by(baltimore, year, type)

## summarize emissions per year and type
per_year <- summarize(balt_year_type, total_emissions = sum(Emissions))

## create plot using ggplot2 plotting system and save to png
png(filename = "plot3.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 

## plot emissions per year per type
## single panel, points with four colors
q <- qplot(year, total_emissions, data=per_year, color=type) + geom_line() + labs(x = "Year", y = "Total Emissions (in Tons)", title="Baltimore City Total Emissions")
print(q)

## close device
dev.off()