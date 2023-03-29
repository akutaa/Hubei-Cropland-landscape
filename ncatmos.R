library(magrittr)
library(ncdf4)
library(terra)

setwd("E:/Data/Atmos/")
# pm <- rast("CHAP_PM2.5_Y1K_2020_V4.nc")
hubei <- vect("E:/Code/data/Hubei.shp")
nclist <- list.files(pattern = "nc") %>% strsplit(split = " ")

ncprcs <- function(x)
{ 
  rast(x)%>%
    project(crs(hubei))%>%
    crop(hubei,mask=TRUE)%>%
    writeRaster(filename = paste0("hubei_PM25_", substr(x,16,19), ".tif"))
}

lapply(nclist, ncprcs)

# tbd
pm <- rast("hubei_PM25_2020.tif")
pmfill <- focalValues(pm)
pmfil <- rast(pmfill)
writeRaster(pmfil,filename = "fill2020.tif")
