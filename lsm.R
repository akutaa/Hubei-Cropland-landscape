library(conflicted)
library(parallel)
library(magrittr)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

# shape metric: contig, frac, shape, 
# core area metric: cai, dcad, 
# area and edge metric: ed, lpi, 
# aggregation metric: ai, lsi, pd

setwd("E:/Code/data/")

selsm <- function(yr, scl)
{
  print(paste('start',yr,scl,'km','...',sep = ' '))
  inRas <- rast(paste0('CLCD',yr,'_200m_01.tif'))
  print(paste0('read ','CLCD',yr,'_200m_01.tif','...'))
  fishnet <- st_read(paste0('net',scl,'km.shp'))
  mtrc <- sample_lsm(landscape = inRas,
                     y = fishnet,
                     level = 'class',
                     metric = c(
                       'contig', 'frac', 'shape', 
                       'cai', 'dcad', 
                       'ed', 'lpi', 
                       'ai', 'lsi', 'pd'
                     ),
                     plot_id = fishnet$PID,
                     directions = 8,
                     neighbourhood = 8,
                     progress = TRUE
                     )
  print(paste0(yr,' ',scl,'km calc done!'))
  save(mtrc,file = paste0(yr,'_',scl,'km.RData'))
  mtrc2 <- mtrc
  mtrc2 <- dplyr::filter(mtrc, class == 1) %>% 
    pivot_wider(names_from = metric,values_from = value)
  outfishnet <- merge(x = fishnet,y = mtrc2,by.x="PID",by.y="plot_id",all.x=TRUE) %>% 
    st_write(paste0('out_',yr,'_',scl,'km.shp'))
  print(paste0(yr,' ',scl,'km complete!'))
}


yrlist <- c(2000, 2005, 2010, 2015, 2020)
scllist <- c(3:10)

cl.cores <- detectCores()
cl <- makeCluster(cl.cores)

t1 <- Sys.time()
parLapply(scllist, function(scl){mapply(selsm, yrlist, scl)},cl = cl)
t2 <- Sys.time()
timeuse <- t2-t1
print(timeuse)



