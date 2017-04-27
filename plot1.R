## plot1.R --> plot1.png

## Question:  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
## for each of the years 1999, 2002, 2005, and 2008.

## Answer:  Yes, total emissions per year have decresed in the US from 1999 to 2008.

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

## group data by years
by_years <- group_by(NEI, year)

## find total emissions from all sources for each year (1999, 2002, 2005 & 2008)
plot1_df <- summarize(by_years, emissions = sum(Emissions, na.rm=TRUE))

## divide elements in emissions column by 1,000,000 to y-axis shows millions of tons (eliminates scientific notation)
## (creates a third column)
plot1_df_mill <- mutate(plot1_df, emissions/1000000)

## create plot using base plotting system and save to png

png(filename = "plot1.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 

## create plot
with(plot1_df_mill, plot(year, `emissions/1e+06`, xlab = "Year", ylab = "Total Emissions (Millions of Tons)", pch=19, xlim = range(1998, 2008)))

## add title
title("Total Emissions Per Year in the United States")

## close device
dev.off()
