setwd("E:/Code/data/")
library(conflicted)
library(magrittr)
library(tidyverse)
library(tidyr)
library(terra)
library(sf)
library(landscapemetrics)

gd10[gd10==-9999] <- 0
