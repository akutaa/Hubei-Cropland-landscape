library(magrittr)
library(ncdf4)
library(terra)


setwd("E:/Data/Prcp/")
# 0. select specified year and write, e.g.
nc <- rast("pre_2015_2017.nc",lyrs = c(1:12))%>%
  writeCDF(filename = "pre_2015.nc")

# 1. from monthly to yearly batch prepare
hubei <- vect("E:/Code/data/Hubei.shp")
nclist <- list.files(pattern = "nc") %>% strsplit(split = " ")
#tricks: prepend "." to sub directory that shall not be listed

# 2.1. do with apply
ncprcs <- function(x)
  { 
  rast(x)%>%
    project(crs(hubei))%>%
    crop(hubei,mask=TRUE)%>%
    mean()%>%
    writeRaster(filename = paste0("hubei_", substr(x,1,8), ".tif"))
  }

lapply(nclist, ncprcs)

# 2.2 do with for
for (i in nclist){
  rast(i)%>%
    project(crs(hubei))%>%
    crop(hubei,mask=TRUE)%>%
    mean()%>%
    writeRaster(filename = paste0("hubei_", substr(i,1,8), ".tif"))
}

