setwd("E:/Code/data/")
library(conflicted)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

inRas <- rast("2020HBrec.tif")
# check_landscape(inRas,verbose = TRUE)
plot(inRas)

# inVec <- st_read("Hubei.shp")
# rawGrid <- st_make_grid(x = inVec,cellsize = 10000,what = "polygons",square = TRUE)

# samplePoint <- st_read("HubeiSP10km.shp")
samplePoint <- st_read("HubeiSP5km.shp")
plot(samplePoint)

# selected lsm: 
# ai, ca, lpi, np, pland, circle_cv, contig_cv, frac_cv, para_mn, shape_cv, cai_cv, core_cv, dcore_cv
# ndca, tca, area_cv, ed, gyrate_cv, te, cohesion, division, lsi, pladj
# pafrac with multiple NA
# issue: cannot calculate by using level and metric

#!!!!!!!!remember to update when scale changed!!!!!!!!!
gridLength <- 5000
metric <- sample_lsm(inRas,
                     y = samplePoint,
                     level = "class",
                     metric = c(
                       'contig',
                       'frac',
                       'shape',
                       'area',
                       'ed',
                       'pland',
                       'ai',
                       'cohesion',
                       'lsi',
                       'np'
                       ),
                     # type = "shape metric",
                     plot_id = samplePoint$GRID_ID,
                     shape = "square",
                     size = gridLength/2,
                     all_classes = FALSE,
                     directions = 8,
                     neighbourhood = 8,
                     return_raster = FALSE,#whether to check raster
                     verbose = TRUE,
                     progress = TRUE)

# if return raster TRUE, plot
# plot(metric$raster_sample_plots[[1]])

# bkup for calc metric
metric2 <- metric

#check duplicate value
# metric2 %>%
#   dplyr::group_by(layer, level, class, id, plot_id, percentage_inside, metric) %>%
#   dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
#   dplyr::filter(n > 1L) 

# pay attention to U-42 cell, maybe NA

metric2 <- dplyr::filter(metric2, class == 1)
metric2 <- pivot_wider(data = metric2,names_from = metric,values_from = value)
outGrid <- merge(x = samplePoint,y = metric2,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)

plot(outGrid, max.plot = 30)
plot(outGrid["shape_sd"])

# corr
corr <- calculate_correlation(metrics = metric,method = "pearson")
show_correlation(data = corr,method = "pearson")

# reset environment
rm(metric, metric2, outGrid)

