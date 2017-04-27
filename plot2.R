## plot2.R --> plot2.png

## Question: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.

## Answer: Total emissions in Baltimore City have bounced around from 1999 to 2008, but overall, have gone down.  
## Emission levels in 2008 are significantly less than they were in 1999.

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

## extract data for Baltimore City, fips = "24510"
baltimore <- filter(NEI, fips == "24510")

## group by years
baltimore_by_years <- group_by(baltimore, year)

## find total emissions from all sources for each year (1999, 2002, 2005 & 2008)
plot2_df <- summarize(baltimore_by_years, emissions = sum(Emissions, na.rm=TRUE))

## create plot using base plotting system and save to png

png(filename = "plot2.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 

## create plot
with(plot2_df, plot(year, emissions, xlab = "Year", ylab = "Total Emissions (in Tons)", pch=19, xlim = range(1998, 2008)))

## add title
title("Baltimore City Total Emissions Per Year")

## close device
dev.off()
