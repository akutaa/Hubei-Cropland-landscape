library(magrittr)
library(terra)

setwd("E:/Data/Nightlight/")

hubei <- vect("E:/Code/data/Hubei.shp")
tiflist <- list.files(pattern = "tif") %>% strsplit(split = " ")

tifprcs <- function(x)
{ 
  rast(x)%>%
    project(crs(hubei))%>%
    crop(hubei,mask=TRUE)%>%
    writeRaster(filename = paste0("hubei_NL", substr(x,13,16), ".tif"))
}

lapply(tiflist, tifprcs)
