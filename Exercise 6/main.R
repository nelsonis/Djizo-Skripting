#Exercise 6
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#16-01-2017

#importing needed libaries and files
library(rgdal)
library(sp)
library(rgeos)

#create important functions, for NDVI and cloud restoration

#Downloading and unpacking files
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip",
              destfile = 'Temp/Places.zip', method = 'auto', mode = "wb")
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip",
              destfile = 'Temp/Railways.zip', method = 'auto', mode = "wb")
unzip('Temp/Places.zip', exdir = 'Temp')
unzip('Temp/Railways.zip', exdir = 'Temp')

#read shapefiles
railways <- readOGR(dsn="Temp", layer = "railways")
places <- readOGR(dsn="Temp", layer = "places")

#reproject to RD_new
sp_railways <- spTransform(railways, CRS("+init=epsg:28992"))
sp_places <- spTransform(places, CRS("+init=epsg:28992"))

#select industrial railways
rail_selection <- sp_railways[ which(sp_railways$type=='industrial'),]

#create a buffer and intersect it with the places file
rail_buffer <- gUnaryUnion(gBuffer(rail_selection, byid=TRUE, width = 1000))
BufferCities <- gIntersects(sp_places, rail_buffer, byid = TRUE)

#create a subset of cities within the buffer
city <- subset(sp_places, BufferCities[1,])

#plot the map and save it to drive
png('Output/Result.png')
plot(rail_buffer, axes=TRUE)
text(labels='Industrial railway', pos=3, cex=1.5)
points(city, col= "red", pch = 21, lwd=7)
text(city, labels=city[[2]], pos=3, cex=1.5)
box()
grid()
mtext(side = 3, line = 1, "Bufferzone Industrial Railway", cex = 2)
mtext(side = 1, "Meters (RD)", line = 2.5, cex=1.1)
mtext(side = 2, "Meters (RD)", line = 2.5, cex=1.1)
dev.off()

#cleaning up
do.call(file.remove, list(list.files("Temp", full.names = TRUE)))



