setwd("E:/Code/data/")
library(conflicted)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

inRas <- rast("2020HB1.tif")

samplePoint <- st_read("HubeiSP3km.shp")
gridLength <- 3000
metric <- sample_lsm(inRas,
                     y = samplePoint,
                     level = "class",
                     # metric = c(
                     #   'np',
                     #   'lsi',
                     #   'ai',
                     #   'ed',
                     #   'area'
                     #   ),
                     type = "shape metric",
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = gridLength/2,#!!!!!!!!remember to update when scale changed!!!!!!!!!
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

save(metric,file = "2020_3km_shape.RData")
rm(metric)

metric <- sample_lsm(inRas,
                     y = samplePoint,
                     level = "class",
                     # metric = c(
                     #   'np',
                     #   'lsi',
                     #   'ai',
                     #   'ed',
                     #   'area'
                     #   ),
                     type = "core area metric",
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = gridLength/2,#!!!!!!!!remember to update when scale changed!!!!!!!!!
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

save(metric,file = "2020_3km_coar.RData")
rm(metric)

metric <- sample_lsm(inRas,
                     y = samplePoint,
                     level = "class",
                     # metric = c(
                     #   'np',
                     #   'lsi',
                     #   'ai',
                     #   'ed',
                     #   'area'
                     #   ),
                     type = "area and edge metric",
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = gridLength/2,#!!!!!!!!remember to update when scale changed!!!!!!!!!
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

save(metric,file = "2020_3km_ared.RData")
rm(metric)

metric <- sample_lsm(inRas,
                     y = samplePoint,
                     level = "class",
                     # metric = c(
                     #   'np',
                     #   'lsi',
                     #   'ai',
                     #   'ed',
                     #   'area'
                     #   ),
                     type = "aggregation metric",
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = gridLength/2,#!!!!!!!!remember to update when scale changed!!!!!!!!!
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

save(metric,file = "2020_3km_aggr.RData")
rm(metric)

# bkup for calc metric
metric2 <- metric

# pay attention to U-42 cell, maybe NA

metric2 <- dplyr::filter(metric2, class == 1)
metric2 <- pivot_wider(data = metric2,names_from = metric,values_from = value)
outGrid <- merge(x = samplePoint,y = metric2,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)

plot(outGrid)
plot(outGrid["frac_cv"])
plot(outGrid, max.plot = 30)
