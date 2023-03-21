setwd("E:/Code/data/")
library(conflicted)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

inRas <- rast("2021_Hubei_Re.tif")
check_landscape(inRas,verbose = TRUE)
plot(inRas)

# inVec <- st_read("Hubei.shp")
# rawGrid <- st_make_grid(x = inVec,cellsize = 10000,what = "polygons",square = TRUE)

samplePoint <- st_read("HubeiSP10km.shp")
plot(samplePoint)

# selected lsm: 
# ai, ca, lpi, np, pland, circle_cv, frac_cv
# issue?
metric <- sample_lsm(inRas,
                     y = samplePoint,
                     # level = "class",
                     # metric = c("frac_cv","frac_mn","frac_sd"),
                     what = c("lsm_c_frac_cv","lsm_c_frac_mn","lsm_c_frac_sd"),
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = 5000,#remember to update when scale changed
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

# if return raster TRUE, plot
# plot(metric$raster_sample_plots[[1]])

metric <- pivot_wider(data = metric,names_from = metric,values_from = value)
metric <- dplyr::filter(metric, class == 1)

outGrid <- merge(x = samplePoint,y = metric,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)

plot(outGrid["frac_cv"])
plot(outGrid)
plot(outGrid, max.plot = 13)
