#Final assignment
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#2 februari 2017
#script should only be executed from the master bash.sh file


#importing needed libaries
library(raster)

#loading the raster and getting raster size
landmass <- raster('Temp/rawoceanraster.tif')
res <- res(landmass)[[1]]

#removing the caspian sea from the raster
ymin <- 42/res
ymax <- 56/res 
xmin <- 45/res + (180/res)
xmax <- 60/res + (180/res)

landmass[ymin:ymax, xmin:xmax] <- NA

#write output to disk
writeRaster(landmass, 'Temp/ocean.tif', format = 'GTiff', overwrite = TRUE)