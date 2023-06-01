# -*- coding: UTF-8 -*-
import arcpy
from arcpy.sa import *

arcpy.env.workspace = 'E:/Code/data/gd/dyna/'
arcpy.env.overwriteOutput = 1
outPath = 'E:/Code/data/gd/dyna/out/'

yearlist = ['2000', '2005', '2010', '2015', '2020']
print(yearlist)
scllist = ['3','4','5','6','7','8','9','0']
print(scllist)

#f03_1995.tif
#012345678901

def crop_dyna(year, scl):
    ''
    #栅格计算
    ras='f0'+scl+'_'+year+'.tif'
    scl = ras[2]
    last5yras = 'f0'+scl+'_'+str(int(year)-5)+'.tif'
    outras = RasterCalculator([ras, last5yras], ["x", "y"], "x-y")
    outras.save(outPath+'dyna_'+ras)
    return print(last5yras + '---->'+ras +' processed successfully!\n')

for yr in yearlist:
    for sc in scllist:
        crop_dyna(yr,sc)