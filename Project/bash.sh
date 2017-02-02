#! /bin/bash

echo ""
echo "Landloss calculator by the Dzjio Skripters"
echo "Gersom Zomer & Yannick Mijnheer"
echo "version 1.0, build 02-02-2017"

mkdir -p ./Temp
mkdir -p ./Output

echo ""
while true; do
   read -p "Is this the first time running this script [y/n]?" yn
    case $yn in
        [Yy]* ) Rscript R/Set-up.R ; break;;
        [Nn]*) break;;
        * ) echo "Please answer yes or no.";;
    	esac
done

echo ""
while [[ -z "$size" ]]
do
  read -p "Set the raster cell size in degrees (source has a cellsize of 0.00416667): " size
done

while [[ -z "$level" ]]
do
  read -p "Give the sea level rise in meters: " level
done

echo ""
while true; do
   read -p "Do you wish to keep Antartica (calculations will take longer) [y/n]?" yn
    case $yn in
        [Yy]*) ANT=0 ; break;;
        [Nn]*) ANT=1 ; break;;
        * ) echo "Please answer yes or no.";;
    	esac
done

echo ""
while true; do
   read -p "Do you wish to remove the temporary files after completion? (not recommended if the script will be run again)[y/n]?" yn
    case $yn in
        [Yy]*) rm -r Temp ; break;;
        [Nn]*) break;;
        * ) echo "Please answer yes or no.";;
    	esac
done

if [ ! -f Temp/World_DEM.tif ]; then
	echo "World_DEM not found, downloading needed files and generating World_DEM!"
	echo ""
	wget -O Temp/15-A.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-A.zip"
	wget -O Temp/15-B.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-B.zip"
	wget -O Temp/15-C.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-C.zip"
	wget -O Temp/15-D.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-D.zip"
	wget -O Temp/15-E.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-E.zip"
	wget -O Temp/15-F.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-F.zip"
	wget -O Temp/15-G.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-G.zip"
	wget -O Temp/15-H.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-H.zip"
	wget -O Temp/15-I.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-I.zip"
	wget -O Temp/15-J.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-J.zip"
	wget -O Temp/15-K.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-K.zip"
	wget -O Temp/15-L.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-L.zip"
	wget -O Temp/15-M.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-M.zip"
	wget -O Temp/15-N.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-N.zip"
	wget -O Temp/15-O.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-O.zip"
	wget -O Temp/15-P.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-P.zip"
	wget -O Temp/15-Q.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-Q.zip"
	wget -O Temp/15-R.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-R.zip"
	wget -O Temp/15-S.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-S.zip"
	wget -O Temp/15-T.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-T.zip"
	wget -O Temp/15-U.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-U.zip"
	wget -O Temp/15-V.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-V.zip"
	wget -O Temp/15-W.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-W.zip"
	wget -O Temp/15-X.zip "http://www.viewfinderpanoramas.org/DEM/TIF15/15-X.zip"

	unzip Temp/15-A.zip -d Temp
	unzip Temp/15-B.zip -d Temp
	unzip Temp/15-C.zip -d Temp
	unzip Temp/15-D.zip -d Temp
	unzip Temp/15-E.zip -d Temp
	unzip Temp/15-F.zip -d Temp
	unzip Temp/15-G.zip -d Temp
	unzip Temp/15-H.zip -d Temp
	unzip Temp/15-I.zip -d Temp
	unzip Temp/15-J.zip -d Temp
	unzip Temp/15-K.zip -d Temp
	unzip Temp/15-L.zip -d Temp
	unzip Temp/15-M.zip -d Temp
	unzip Temp/15-N.zip -d Temp
	unzip Temp/15-O.zip -d Temp
	unzip Temp/15-P.zip -d Temp
	unzip Temp/15-Q.zip -d Temp
	unzip Temp/15-R.zip -d Temp
	unzip Temp/15-S.zip -d Temp
	unzip Temp/15-T.zip -d Temp
	unzip Temp/15-U.zip -d Temp
	unzip Temp/15-V.zip -d Temp
	unzip Temp/15-W.zip -d Temp
	unzip Temp/15-X.zip -d Temp
	rm Temp/*.zip

	echo ""
	echo "Merging DEM map"
	gdal_merge.py Temp/*.tif -o Temp/World_DEM.tif
	rm Temp/15-*.tif	
fi

if [ ! -f Temp/ne_10m_ocean.shp ]; then
	echo "Oceans vector not found, Downloading needed data"
	echo ""
	wget -O Temp/ocean-vectors.zip "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_ocean.zip"	
	unzip Temp/ocean-vectors.zip -d Temp
	rm Temp/*.zip
fi

echo ""
echo "Resizing DEM map"
gdalwarp -overwrite -r cubic -tr "$size" "$size" Temp/World_DEM.tif Temp/DEM_resample.tif

echo ""
echo "Rasterizing Sea vector"
gdal_rasterize  -burn -9999  -a_srs "+proj=longlat +ellps=WGS84" -tr  "$size" "$size" -a_nodata 0 -ot Int16 Temp/ne_10m_ocean.shp Temp/rawoceanraster.tif

echo""
echo "Preprocessing sea raster"
Rscript R/Rm_Caspian.R 

if [ -f Output/workingraster.tif ]; then
	rm Output/workingraster.tif
fi

echo ""
echo "Creating working raster"
gdal_merge.py Temp/DEM_resample.tif Temp/ocean.tif -o Output/workingraster.tif
Rscript R/Rm_antartica.R "$ANT"
			
echo""
echo "Calculating new sea map"
Rscript R/Sea_rise.R "$level"
rm Output/workingraster.tif
echo "Operations done!"

echo ""
echo "Creating HTML output viewer"
Rscript R/Shiny.R "$size" "$level"
eval xdg-open result_${size}deg_${level}meters.html
echo ""