library(conflicted)
library(magrittr)
library(snowfall)
library(tidyverse)
library(tidyr)
library(readxl)
library(terra)
library(sf)
library(landscapemetrics)
library(GD)

setwd("E:/Code/data/gd/")


# 指定年份
yr <- "opnt_2000"
# 指定因变量序列
indepenVar <- c('ai','cai_cv','cai_mn','cai_sd','cntg_cv','cntg_mn','cntg_sd',
                'dcad','ed','frac_cv','frac_mn','frac_sd',
                'lpi','lsi','pd',	'shap_cv','shap_mn','shap_sd')

# 以xlsx名称批量建立变量并赋值，组成列表
file_names <- list.files(pattern = yr) %>% strsplit(split = " ")
dataList <- lapply(file_names, function(file_name) {
  assign(sub(".xlsx", "", file_name), read_xlsx(file_name) %>% 
           as.data.frame() 
         # %>% dplyr::filter(prcntg_!=0)
         )
  get(sub(".xlsx", "", file_name))
}) %>%
  setNames(sub(".xlsx", "", file_names))

# discmethod <- c('equal', 'natural', 'quantile', 'geometric', 'sd')
discmethod <- c('equal', 'natural', 'quantile', 'sd')
discitv <- c(3:8)
continuous_variable <- c('GDP','NTL','PM25','POP','PRE','TMP','SLP','ELV','DYNA')
su <- c(3:10) ##指定尺度序列

# shape metric: contig, frac, shape, 
# core area metric: cai, dcad, 
# area and edge metric: ed, lpi, 
# aggregation metric: ai, lsi, pd

gdFmla <- as.formula(paste0(indepenVar,'~ GDP+NTL+PM25+POP+PRE+TMP+SLP+ELV+SOIL+DYNA'))

gdList <- lapply(dataList, function(x){
  gdm(cntg_cv ~ GDP+NTL+PM25+POP+PRE+TMP+SLP+ELV+SOIL+DYNA,
      continuous_variable = continuous_variable,
      data = x,
      discmethod = discmethod,
      discitv = discitv)
})

tgd <- gdList$opnt_2000_03
pdf(file = 'tgd.pdf',width = 10)
plot(tgd)
dev.off()

# png(filename = paste0(yr,'_sesu.png'),
#     width = 1920,height = 1080,units = 'px',pointsize = 7,res = 250,
#      antialias = 'gray')
# pdf(file = paste0(yr,'_sesu.pdf'),width = 10)
sesu(gdList, su) #绘制尺度效应图
# dev.off()

gdNameList <- names(gdList) %>% strsplit(split = ' ')


lapply(gdNameList, function(x){
  sink(paste0(x,'.txt'))
  gdList$x
  sink()
  currName <- assign(paste0(x,'_','cntg_cv'),gdList$x)
  #get(paste0(x,'_','cntg_cv'))
  imgName <- paste0(currName,'.pdf')
  pdf(imgName,width = 10)
  plot(currName)
  dev.off()
})

