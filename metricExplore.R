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
yr <- '2005'
ptn <- paste0(yr,".*.xlsx")

# 批量读取xlsx，以文件名称（无扩展名）批量建立变量并赋值，组成用于分析的原始数据列表
file_names <- list.files(pattern = ptn) %>% strsplit(split = " ")
dataList <- lapply(file_names, function(file_name) {
  assign(sub(".xlsx", "", file_name), read_xlsx(file_name) %>% 
           as.data.frame() 
         # %>% dplyr::filter(prcntg_!=0)
  )
  get(sub(".xlsx", "", file_name))
}) %>% setNames(sub(".xlsx", "", file_names))

gdNameList <- names(dataList) %>% strsplit(split = ' ')


# 指定因变量序列
metricList <- c('ai','cai_cv','cai_mn','cai_sd','cntg_cv','cntg_mn','cntg_sd',
                'dcad','ed','frac_cv','frac_mn','frac_sd',
                'lpi','lsi','pd',	'shap_cv','shap_mn','shap_sd')

#指定离散方法
discmethod <- c('equal', 'natural', 'quantile', 'sd')
#指定离散阈值
discitv <- c(3:8)
#指定需离散的连续性解释变量
continuous_variable <- c('GDP','NTL','PM25','POP','PRE','TMP','SLP','ELV','DYNA')
#指定尺度序列
su <- c(3:10) 


# shape metric: contig, frac, shape, 
# core area metric: cai, dcad, 
# area and edge metric: ed, lpi, 
# aggregation metric: ai, lsi, pd


lapply(metricList, function(y){#e.g. y=cntg_cv(str)
  #指定Formula
  gdFmla <- as.formula(paste0(y,'~ GDP+NTL+PM25+POP+PRE+TMP+SLP+ELV+SOIL+DYNA'))
  gdList <- lapply(dataList, function(x){#e.g. x=opnt_2000_03(df)
    gdm(gdFmla,
      continuous_variable = continuous_variable,
      data = x,
      discmethod = discmethod,
      discitv = discitv)
  })
  save(gdList,file = paste0(yr,'_',y,'_3to10.RData'))
  
  pdf(file = paste0(yr,'_',y,'_sesu.pdf'),width = 10)
  sesu(gdList, su) #绘制尺度效应图
  dev.off()
  
  lapply(gdNameList, function(z){#e.g. z=opnt_2000_03(str)
    capture.output(gdList[[z]],file = paste0(z,'_',y,'.txt'))
    pdf(paste0(z,'_',y,'.pdf'),width = 10)
    plot(gdList[[z]])
    dev.off()
  })
})







