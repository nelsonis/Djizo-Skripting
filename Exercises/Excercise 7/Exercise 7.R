#Dzjio Skripting
#Exercise 7
#Gersom Zomer & Yannick Mijnheer
#17 january 2017

#download needed libaries and files
if(!require(rgdal)) {  install.packages("rgdal")}
if(!require(raster)) {  install.packages("raster")}
if(!require(sp)) {  install.packages("sp")}

#import needed libaries
library(rgdal)
library(raster)
library(sp)

#downloading and preprocessing of files
download.file("https://raw.githubusercontent.com/GeoScripting-WUR/VectorRaster/gh-pages/data/MODIS.zip", destfile = "Temp/MODIS.zip")
unzip("Temp/MODIS.zip", exdir="Temp")
modis <- stack("Temp/MOD13A3.A2014001.h18v03.005.grd")

nlMunicipality <- spTransform(getData('GADM',country='NLD', level=2, path="Temp"), CRS(proj4string(modis)))
nl <- spTransform(getData('GADM',country='NLD', level=0, path="Temp"), CRS(proj4string(modis)))
province <- spTransform(getData('GADM',country='NLD', level=1, path="Temp"), CRS(proj4string(modis)))


#calculating the maximum for January
jan <- mask(subset(modis, "January"), nl)
jan_data <- extract(jan, nlMunicipality, df=TRUE )
jan_mean <- aggregate(jan_data[,2], jan_data[1], mean)
jan_municipality <- cbind.data.frame(nlMunicipality[7:8], jan_mean$x)
janmax <- subset(jan_municipality[2], jan_municipality$`jan_mean$x` == max(jan_municipality$`jan_mean$x`, na.rm = TRUE)) 

#calculation the maximum for August
aug <- mask(subset(modis, "August"), nl)
aug_data <- extract(aug, nlMunicipality, df=TRUE )
aug_mean <- aggregate(aug_data[,2], aug_data[1], mean)
aug_municipality <- cbind.data.frame(nlMunicipality[7:8], aug_mean$x)
augmax <- subset(aug_municipality[2], aug_municipality$`aug_mean$x` == max(aug_municipality$`aug_mean$x`, na.rm = TRUE))

#calculating the maximum for the year
year <- mask(modis, nl)
year_data <- extract(year, nlMunicipality, df=TRUE )
year_mean <- data.frame(ID=year_data[,1], mean=rowMeans(year_data[,2:13]))
year_aggregate  <- aggregate(year_mean[,2], year_mean[1], mean)
year_municipality <- cbind.data.frame(nlMunicipality[7:8], year_aggregate$x)
yearmax <- subset(year_municipality[2], year_municipality$`year_aggregate$x` == max(year_municipality$`year_aggregate$x`, na.rm = TRUE)) 

#calculating the maximum for January for a province
janprov <- mask(subset(modis, "January"), nl)
janprov_data <- extract(janprov, province, df=TRUE )
janprov_mean <- aggregate(janprov_data[,2], janprov_data[1], mean)
janprov_municipality <- cbind.data.frame(province[5:6], janprov_mean$x)
janprovmax <- subset(janprov_municipality[2], janprov_municipality$`janprov_mean$x` == max(janprov_municipality$`janprov_mean$x`, na.rm = TRUE))

#Creating map with the result and save it to disk
png('Output/Result.png')
plot(jan)
lines(subset(nlMunicipality, nlMunicipality$NAME_2 == yearmax[1,1]), col = "purple", lwd = 2 )
invisible(text(getSpPPolygonsLabptSlots(subset(nlMunicipality, nlMunicipality$NAME_2 == yearmax[1,1])),
               labels = as.character(yearmax), cex = 0.9, col = "black", font = 2, pos = 3))
lines(subset(nlMunicipality, nlMunicipality$NAME_2 == janmax[1,1]), col = "blue", lwd = 2 )
invisible(text(getSpPPolygonsLabptSlots(subset(nlMunicipality, nlMunicipality$NAME_2 == janmax[1,1])),
               labels = as.character(janmax), cex = 0.9, col = "black", font = 2, pos = 3))
lines(subset(nlMunicipality, nlMunicipality$NAME_2 == augmax[1,1]), col = "red", lwd = 2)
invisible(text(getSpPPolygonsLabptSlots(subset(nlMunicipality, nlMunicipality$NAME_2 == augmax[1,1])),
               labels = as.character(augmax), cex = 0.9, col = "black", font = 2, pos = 3))
mtext(side = 3, line = 1, "Greenest Municipalities of the Netherlands", cex = 1.5)
mtext(side = 1, "Meters (RD)", line = 2.5, cex=1.1)
mtext(side = 2, "Meters (RD)", line = 2.5, cex=1.1)
legend(x="topleft", legend=c('Max Year','Max January', 'Max August'), col=c("purple","blue", 'red'), lwd = 2)
dev.off()

#cleaning up
do.call(file.remove, list(list.files("Temp", full.names = TRUE)))
