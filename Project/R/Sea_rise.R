#Final assignment
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#2 februari 2017
#script should only be executed from the master bash.sh file


#importing needed libaries
library(raster)

#reading input from terminal
args = commandArgs(trailingOnly=TRUE)
level <- as.integer(args)

#loading input raster
world <- raster('Output/workingraster.tif')

#creating 2 dataframes from raster for calculation
worldDF  <- as.matrix(world)
SelectDF <- (worldDF <= level & worldDF > -9999)
iter     <- 0

#the function calculating the pixels which will be flooded
LoopFun <- function(Land,LandDF,SelectDF) {
  nr <- nrow(SelectDF)
  nc <- ncol(SelectDF)
  for (i in 1:nr) { for (j in 1:nc) {
    if (i==1 & j==1 & SelectDF[i,j]==1) {           # left upper corner
      if (LandDF[i+1,j] == -9999 | LandDF[i,j+1] == -9999) {
        Land[i,j] <- -9999 } }
    else if (i==1 & j==nc & SelectDF[i,j]==1) {     # right upper corner
      if (LandDF[i,j-1] == -9999 | LandDF[i+1,j] == -9999) {
        Land[i,j] <- -9999 } }
    else if (i==nr & j==nc & SelectDF[i,j]==1) {    # right lower corner
      if (LandDF[i,j-1] == -9999 | LandDF[i-1,j] == -9999) {
        Land[i,j] <- -9999 } }
    else if (i==nr & j==1 & SelectDF[i,j]==1) {     # left lower corner
      if (LandDF[i,j+1] == -9999 | LandDF[i-1,j] == -9999) {
        Land[i,j] <- -9999 } }
    else if (i==1 & SelectDF[i,j]==1) {             # upper border
      if (LandDF[i,j-1] == -9999 | LandDF[i,j+1] == -9999 | LandDF[i+1,j] == -9999) {
        Land[i,j] <- -9999 } }
    else if (i==nr & SelectDF[i,j]==1) {            # lower border
      if (LandDF[i,j-1] == -9999 | LandDF[i,j+1] == -9999 | LandDF[i-1,j] == -9999) {
        Land[i,j] <- -9999 } }
    else if (j==1 & SelectDF[i,j]==1) {             # left border
      if (LandDF[i-1,j] == -9999 | LandDF[i+1,j] == -9999 | LandDF[i,j+1] == -9999) {
        Land[i,j] <- -9999 } }
    else if (j==nc & SelectDF[i,j]==1) {            # right border
      if (LandDF[i-1,j] == -9999 | LandDF[i+1,j] == -9999 | LandDF[i,j-1] == -9999) {
        Land[i,j] <- -9999 } }
    else if (SelectDF[i,j] == 1) {
      if (LandDF[i-1,j] == -9999 | LandDF[i+1,j] == -9999 | LandDF[i,j-1] == -9999 | LandDF[i,j+1] == -9999 ) {
        Land[i,j] <- -9999 } }                      # everything in the middle
  } } 
  return(Land)
}

#print feed back to the terminal
cat("")
cat("Starting loop")

#initiate the loop
world <- LoopFun(world, worldDF, SelectDF)
worldDF <- as.matrix(world)

#continue the loop until no more cells are added to the water
time <- system.time(
  while (ncell(worldDF[worldDF != -9999 & worldDF<=level]) < ncell(SelectDF[SelectDF == TRUE])) {
    SelectDF  <- (worldDF <= level & worldDF > -9999)
    world <- LoopFun(world, worldDF, SelectDF)
    worldDF <- as.matrix(world)
    iter = iter + 1
    cat("\r",iter,"iterations")
  })

#print the elapsed time to the terminal
cat("\n")
cat("Time elapsed",time[1],"seconds")

#remove unwanted values, from the output and write it to disk.
world[world != -9999] <- NA
world[world == -9999] <- 1
writeRaster(world, "Output/resultraster.tif", format = 'GTiff', overwrite = TRUE)