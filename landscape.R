library(conflicted)
library(magrittr)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

setwd("E:/Code/data/")

inRas <- rast("2020HBrec.tif")
# check_landscape(inRas,verbose = TRUE)
plot(inRas)

# inVec <- st_read("Hubei.shp")
# rawGrid <- st_make_grid(x = inVec,cellsize = 10000,what = "polygons",square = TRUE)

# samplePoint <- st_read("HubeiSP10km.shp")
samplePoint <- st_read("HubeiSP10km.shp")

plot(samplePoint)

# selected lsm: 
# ai, ca, lpi, np, pland, circle_cv, contig_cv, frac_cv, para_mn, shape_cv, cai_cv, core_cv, dcore_cv
# ndca, tca, area_cv, ed, gyrate_cv, te, cohesion, division, lsi, pladj
# pafrac with multiple NA
# issue: cannot calculate by using level and metric

#!!!!!!!!remember to update when scale changed!!!!!!!!!
gridLength <- 10000
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
sampleGrid <- st_read("HubeiGrid7km.shp")
plot(sampleGrid)

metric2 <- dplyr::filter(metric2, class == 1)
metric2 <- pivot_wider(data = metric2,names_from = metric,values_from = value)
outSP <- merge(x = samplePoint,y = metric2,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)
outGrid <- merge(x = sampleGrid,y = metric2,by.x="GRID_ID",by.y="plot_id",all.x=TRUE)


plot(outSP, max.plot = 30)
plot(outSP["frac_cv"])
plot(outGrid, max.plot = 30)
plot(outGrid["frac_cv"])

st_write(outGrid,"2020_3km.shp")
st_write(outSP,"P_2020_7km.shp")

# corr
# corr <- calculate_correlation(metrics = metric,method = "pearson")
# show_correlation(data = corr,method = "pearson")

# batch generate points for gd
GD_point <- function(r){
  load(paste0('2020_',r,'_mtc.RData'))
  m <- dplyr::filter(metric, class == 1) %>%
    pivot_wider(names_from = metric,values_from = value) %>% 
    select(-c(layer,level,class,id))
  p <- st_read(paste0('HubeiSP',r,'.shp')) %>%
    merge(y = m,by.x="GRID_ID",by.y="plot_id",all.x=TRUE) %>%
    st_write(paste0('P_',r,'.shp'))
}

res <- list('3km','5km','7km','10km')
lapply(res, GD_point)

hbtest <- st_read("p10")