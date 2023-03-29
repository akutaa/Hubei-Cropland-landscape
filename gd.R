library(conflicted)
library(magrittr)
library(tidyverse)
library(tidyr)
library(readxl)
library(terra)
library(sf)
library(landscapemetrics)
library(GD)

setwd("E:/Code/data/")

# SP <- read_csv("2020_10km.csv")
# DPD <- read_csv("P_10km.csv")
# GDdata <- merge(x = SP,y = DPD,by.x="GRID_ID",by.y="GRID_ID",all.x=TRUE)
GDData <- read_csv("GD3km.csv") %>% as.data.frame()

discmethod <- c('equal', 'natural', 'quantile', 'geometric', 'sd')
discitv <- c(3:7)
continuous_variable <- colnames(GDData)[-c(1:20,29)]

testgd <- gdm(ed ~ NTL+PM25+GDP+POP+TMP+PRE+ELV+SLP+SOIL,
              continuous_variable = continuous_variable,
              data = GDData,
              discmethod = discmethod,
              discitv = discitv
              )

testgd
plot(testgd)

continuous_variable <- colnames(h1n1_50)[-c(1,11)]
testgd2 <- gdm(H1N1 ~ .,
               continuous_variable = continuous_variable,
               data = h1n1_50,
               discmethod = discmethod,
               discitv = discitv
               )

# area_cv	 cntg_cv	 frac_cv	 shap_cv	
# ai cohesin ed lsi	np pland	
gd3 <- read_xlsx("gddata_3km.xlsx") %>% as.data.frame()
gd5 <- read_xlsx("gddata_5km.xlsx") %>% as.data.frame()
gd7 <- read_xlsx("gddata_7km.xlsx") %>% as.data.frame()
gd10 <- read_xlsx("gddata_10km.xlsx") %>% as.data.frame()
gd3[gd3==-9999] <- 0
gd5[gd5==-9999] <- 0
gd7[gd7==-9999] <- 0
gd10[gd10==-9999] <- 0

gddatalist <- list(gd3, gd5, gd7,gd10)

discmethod <- c('equal', 'natural', 'quantile', 'geometric', 'sd')
discitv <- c(3:7)
continuous_variable <- colnames(gd3)[-c(1:21,30)]

su <- c(3, 5, 7, 10) ## sizes of spatial units
## "gdm" function
gdlist <- lapply(gddatalist, function(x){
  gdm(shap_mn ~ NTL+PM25+GDP+POP+TMP+PRE+ELV+SLP+SOIL,
      continuous_variable = continuous_variable,
      data = x,
      discmethod = discmethod,
      discitv = discitv)
})
sesu(gdlist, su) ## size effects of spatial units


