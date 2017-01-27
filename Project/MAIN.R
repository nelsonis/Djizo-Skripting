library(raster)
library(rgdal)
library(rgeos)

rasters <- list.files(path= "Temp", full.names = TRUE)
rast.list <- list()
for(i in 1:length(rasters)) { rast.list[i] <- raster(rasters[i]) }

rast.list$filename <- 'Output/test.tif'
rast.list$options <- c("COMPRESS=DEFLATE", "ZLEVEL=9")
do.call(merge,rast.list)

