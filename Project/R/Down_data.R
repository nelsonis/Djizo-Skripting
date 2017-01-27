LTR <- function(){
  for (i in LETTERS[1:24]) {
    download.file(url = paste('http://www.viewfinderpanoramas.org/DEM/TIF15/15-',i,'.zip',sep=''), 
                  destfile = paste('Temp/15-',i,'.zip',sep=''), mode = 'wb')
    unzip(paste('Temp/15-',i,'.zip',sep=''), exdir = 'Temp')
    file.remove(paste('Temp/15-',i,'.zip',sep=''))  }
}