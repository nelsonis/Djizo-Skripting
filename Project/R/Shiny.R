#Final assignment
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#2 februari 2017
#script should only be executed from the master bash.sh file


#import needed libaries
library(raster)
library(leaflet)
library(htmlwidgets)

#read arguments for terminal
args = commandArgs(trailingOnly=TRUE)
res <- args[1]
rise <- args[2]

#create HTML map
water <- raster('Output/resultraster.tif')
map <- leaflet() %>% addTiles() %>% addRasterImage(water, colors = "paleturquoise3", opacity = 0.7)

#write the HTML map to disk
name <- paste("result_",res,"deg_",rise,"meters.html", sep="")
saveWidget(map, file = name)