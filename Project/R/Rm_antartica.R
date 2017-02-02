#Final assignment
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#2 februari 2017
#script should only be executed from the master bash.sh file


#reading input form terminal
args = commandArgs(trailingOnly=TRUE)
check <- as.logical(as.integer(args))

#only run script when user want to exclude Antartica
if(check) {
library(raster)

#import raster
working <- raster('Output/workingraster.tif')
res <- res(working)[[1]]

#select the extent of antartica for the files pixel size
ymin <- (60/res) + (90/res)
ymax <- nrow(working)
xmin <- 0
xmax <- ncol(working)

#overwrite antartica as water
working[ymin:ymax, xmin:xmax] <- -9999

#write out raster
writeRaster(working, 'Output/workingraster.tif', format = 'GTiff', overwrite = TRUE)
}