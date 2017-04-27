## plot4.R --> plot4.png

## Question: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

## How I determined "coal combustion-related sources":
## I inspected the data in the SCC file, and decided the SCC.Level.One variable contained the pertinant information 
## for searching for sources of combustion (grep for [Cc]ombustion).  This provided 569 rows.  Not all of these 
## rows concerned coal, however.
## The Short.Name variable provided the information needed to identify which of the combustion sources were
## coal-related (grep for [Cc]oal).  There were a total of 91 SCC values for coal-combustion-related sources.
## These SCC values were used to extract the emission data from the NEI data frame and create a plot that answered 
## the question.

## Answer:  While emissions in the US from coal-combustion sources decreased slightly overall from 1999-2005,
## they showed a large decrease by 2005.

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

## find those SCC values in SCC data frame concerning combustion and coal
## SCC$Level.One looks like best bet - search for "combustion", get relevant rows
lvl_1_comb_rows <- grep("[Cc]ombustion", SCC$SCC.Level.One)

## subset rows in SCC that concern combustion
SCC_comb <- SCC[lvl_1_comb_rows,]

## Not all of these rows involve coal, so search for those that do
## SCC$Short.Name looks like a good column to search for "coal"

scc_comb_coal_rows <- grep("[Cc]oal", SCC_comb$Short.Name)

## subset rows in SCC_comb that involve only coal
SCC_comb_coal <- SCC_comb[scc_comb_coal_rows,]

## Get SCC$SCC values involving combustion and coal (91 of them)
## use these to pull out relevant rows in NEI data frame
SCC_values <- SCC_comb_coal$SCC

## subset NEI so only have rows concerning combustion and coal
selected_rows <- (NEI$SCC %in% SCC_values)
NEI_comb_coal <- NEI[selected_rows,]

## there are 91 SCC values concerning combustion and coal, but, interestingly, only 76 appear in NEI
## 40440 rows in this subset of NEI data frame

## interested in total emissions per year across the US from all combustion/coal sources

NEI_comb_coal_by_years <- group_by(NEI_comb_coal, year)

plot4_df <- summarize(NEI_comb_coal_by_years, emissions = sum(Emissions, na.rm=TRUE))

## total emissions are in hundred of thousand of tons, so divide by 1000 so plot will be clearer
plot4_df_thousands <- mutate(plot4_df, emissions/1000)

## create png of plot

png(filename = "plot4.png", width=480, height=480, units="px", bg="white")

## adjust margins
par(oma = c(0,1,0,0)) 

## create plot
with(plot4_df_thousands, plot(year, `emissions/1000`, xlab = "Year", ylab = "Total Emissions (Thousands of Tons)", pch=19, xlim = range(1998, 2008), ylim = range(300, 600)))
## add title
title("Total Emissions Per Year - Coal Combustion Sources")

## close device
dev.off()

