setwd("E:/Code/Hubei-cropland-landscape/out/")
library(conflicted)
library(tidyverse)
library(terra)
library(sf)
library(landscapemetrics)
inRas <-　rast("E:/Code/data/testRas.tif")
plot(inRas)

check_landscape(inRas,verbose = TRUE)

# testgrid <- st_make_grid(x = inRas,cellsize = 1000,what = "polygons",square = TRUE)
# plot(testgrid)
# testrange <- st_sf(testgrid)
testgrid <- st_read("E:/Code/data/grid_1km_sp.shp")
plot(testgrid)

metric <- sample_lsm(inRas,
                     y = testgrid, what = "lsm_l_shei",
                     plot_id = testgrid$GRID_ID,
                     shape = "square",
                     size = 500,
                     all_classes = FALSE,
                     return_raster = TRUE,
                     verbose = TRUE,
                     progress = TRUE)
outGrid <- merge(x = testgrid,y = metric,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)
plot(outGrid["value"])
