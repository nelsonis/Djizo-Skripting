#Final assignment
#Dzjio Skripting
#Gersom Zomer & Yannick Mijnheer
#2 februari 2017
#script should only be executed from the master bash.sh file


#Checking for needed packages and installing them if needed
list.of.packages <- c("raster", "leaflet", "htmlwidgets")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "https://cloud.r-project.org")