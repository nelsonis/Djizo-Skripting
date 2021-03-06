#Dzjio Skripting
#Exercise 8
#Gersom Zomer & Yannick Mijnheer
#18 january 2017

#libaries
library(raster)

#load data
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB1.rda", "Temp/GewataB1.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB2.rda", "Temp/GewataB2.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB3.rda", "Temp/GewataB3.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB4.rda", "Temp/GewataB4.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB5.rda", "Temp/GewataB5.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/GewataB7.rda", "Temp/GewataB7.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/vcfGewata.rda", "Temp/vcfGewata.rda", quiet = TRUE)
download.file("https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/trainingPoly.rda", "Temp/trainingPoly.rda", quiet = TRUE)

load("Temp/GewataB1.rda")
load("Temp/GewataB2.rda")
load("Temp/GewataB3.rda")
load("Temp/GewataB4.rda")
load("Temp/GewataB5.rda")
load("Temp/GewataB7.rda")
load("Temp/vcfGewata.rda")
load("Temp/trainingPoly.rda")

#cleaning data
vcfGewata[vcfGewata > 100] <- NA
GewataB5[GewataB5 > 10000] <- NA
GewataB7[GewataB7 > 10000] <- NA

## Build a brick containing all data
alldata <- brick(GewataB1, GewataB2, GewataB3, GewataB4, GewataB5, GewataB7, vcfGewata)
names(alldata) <- c("band1", "band2", "band3", "band4", "band5", "band7", "VCF")

## Extract all data to a data.frame
df <- as.data.frame(getValues(alldata))

#create model
model <- lm(VCF ~ band1 + band2 + band3 + band4 + band5, df)
predicted_VCF <- predict(alldata[[1:5]], model)

#calculate the RMSE map and difference map
predicted_VCF[predicted_VCF < 0] <- NA
difference <- vcfGewata - predicted_VCF
RMSE_map <- sqrt( mean( (predicted_VCF-vcfGewata)^2 , na.rm = TRUE ) )

#calculating the RMSE for each class
trainingPoly@data$Code <- as.numeric(trainingPoly@data$Class)
trainingRaster <- rasterize(trainingPoly, difference, field='Code')
covmasked <- mask(difference^2, trainingRaster)
ans <- sqrt(zonal(covmasked, trainingRaster, mean))
rownames(ans) <- c('cropland', 'forest', 'wetland')
result <- ans[,2]

#writing results to disk
writeRaster(difference, "Output/Difference_raster", overwrite = TRUE)
writeRaster(RMSE_map, "Output/RMSE_raster", overwrite = TRUE)

#cleaning up
do.call(file.remove, list(list.files("Temp", full.names = TRUE)))
