setwd("E:/Code/data/")
library(conflicted)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)
# inRas <-　rast("E:/Code/data/testRas.tif")
inRas <- rast("E:/Code/data/CLCD_v01_2021_albert_hubei.tif")
plot(inRas)

check_landscape(inRas,verbose = TRUE)

# testgrid <- st_make_grid(x = inRas,cellsize = 1000,what = "polygons",square = TRUE)
# plot(testgrid)
# testrange <- st_sf(testgrid)
# testgrid <- st_read("E:/Code/data/grid_1km_sp.shp")
testgrid <- st_read("E:/Code/data/HubeiSP10km__.shp")
plot(testgrid)

metric <- sample_lsm(inRas,
                     y = testgrid,
                     level = "class",
                     metric = c("ai","shei"),
                     plot_id = testgrid$GRID_ID,
                     shape = "square",
                     size = 5000,#remember to update when scale changed
                     all_classes = FALSE,
                     return_raster = TRUE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

# if return raster TRUE, plot
plot(metric$raster_sample_plots[[1]])

metric <- pivot_wider(data = metric,names_from = metric,values_from = value)
outGrid <- merge(x = testgrid,y = metric,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)
plot(outGrid["shei"])


