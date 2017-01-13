#Dzjio Skripting
#Exercise 5
#Gersom Zomer & Yannick Mijnheer
#13 january 2017

#importing needed libaries and files
library(rgdal)
library(raster)

#create important functions, for NDVI and cloud restoration
NDVI <- function(x){
  NDVI <- (x[[2]] - x[[1]]) / (x[[2]] + x[[1]])
  return(NDVI)
}

cf_fun <- function(x, y) { 
  x[y != 0] <- NA
  return(x)}


#Downloading and unpacking files
#Extra remark: when downloading the mode should be "wb" on windows 
#otherwise archives are not written properly to disk, for linux system the function default of "w" is fine
download.file(url = "https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=1#",
              destfile = 'Data/Wag_2014109.tar.gz', method = 'auto', mode = "wb")
download.file(url = "https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=1#",
              destfile = 'Data/Wag_1990098.tar.gz', method = 'auto', mode = "wb")
untar('Data/Wag_2014109.tar.gz', exdir = "Data/LANDSAT_5")
untar('Data/Wag_1990098.tar.gz', exdir = "Data/LANDSAT_8")
file.remove('Data/Wag_2014109.tar.gz', 'Data/Wag_1990098.tar.gz')
              
#Preprocessing
#selecting the needed layers for the NDVI, these are band 3 and 4 for landsat 5 and band 4 and 5 for landsat 8
list1990 <- list.files(path = "Data/LANDSAT_5", pattern = glob2rx('*sr_band*'), full.names = TRUE)
list2014 <- list.files(path = "Data/LANDSAT_8", pattern = glob2rx('*sr_band*'), full.names = TRUE)
stack1990 <- stack(list1990[3], list1990[4])
stack2014 <- stack(list2014[4], list2014[5])

# load the cloud layers and prepare them form overlay operations
cloud1990 <- raster('Data/LANDSAT_5/LC81970242014109LGN00_cfmask.tif')
cloud1990[cloud1990 == 0] <- NA
cloud2014 <- raster('Data/LANDSAT_8/LT51980241990098KIS00_cfmask.tif')
cloud2014[cloud2014 == 0] <- NA

#overlay the cloudmaps with the selected bands
Base1990 <- overlay(x = stack1990, y = cloud1990, fun = cf_fun)
Base2014 <- overlay(x = stack2014, y = cloud2014, fun = cf_fun)

#calculate NDVI for both years and write to disk,
#important note datatype should be float, this is set by datatype='FLT4S'
writeRaster(x = NDVI(Base1990), filename = 'Output/NDVI1990.grd', datatype='FLT4S', overwrite=TRUE)
writeRaster(x = NDVI(Base2014), filename = 'Output/NDVI2014.grd', datatype='FLT4S', overwrite=TRUE)

#set the extend for cropping
extend <- intersect(raster('Output/NDVI1990.grd'), raster('Output/NDVI2014.grd'))

#crop both rasters
NVDI1990 <- crop(raster('Output/NDVI1990.grd'), extend)
NVDI2014 <- crop(raster('Output/NDVI2014.grd'), extend)

#calculate difference in NDVI and write to disk
writeRaster(x = NVDI1990 - NVDI2014, filename = 'Output/NDVI_DIFF.grd', datatype='FLT4S', overwrite=TRUE)

#removing uneeded files
do.call(file.remove, list(list.files("Data/LANDSAT_5", full.names = TRUE)))
do.call(file.remove, list(list.files("Data/LANDSAT_8", full.names = TRUE)))