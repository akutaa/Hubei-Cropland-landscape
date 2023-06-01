# -*- coding: UTF-8 -*-
# Author: ChatGPT Mar 14 Version
'''
import arcpy

arcpy.env.workspace = 'E:/Code/data/gd/ext/'
arcpy.env.overwriteOutput = 1

shplist = arcpy.ListFeatureClasses()
raslist = arcpy.ListRasters()

shplist.sort()
raslist.sort()

print(shplist)
print(raslist)
# dyna_2000_03.tif
# 0123456789012345
# opnt_2000_03.shp

for shp in shplist:
    for ras in raslist:
        if shp[5:11]==ras[5:11]:
            print(ras+' ----> '+shp+'\n')
            arcpy.sa.ExtractMultiValuesToPoints(shp, ras+' DYNA',"NONE")
'''

import arcpy
import os

def extract_year(filename):
    """从文件名中提取年份"""
    year = int(filename.split('_')[1])
    return year

def extract_label(filename):
    """从文件名中提取标记号"""
    label = int(filename.split('_')[2][:-4])
    return label

def process_matching_files(file1, file2):
    """处理匹配的两个文件"""
    # 使用arcpy处理工具来处理这两个文件
    arcpy.sa.ExtractMultiValuesToPoints(file2, file1+' DYNA',"NONE")

# 设置工作空间
arcpy.env.workspace = 'E:/Code/data/gd/ext/'
arcpy.env.overwriteOutput = 1

# 获取第一组文件列表
raster_list = arcpy.ListRasters()
# 获取第二组文件列表
feature_class_list = arcpy.ListFeatureClasses()

# 遍历第一组文件
for raster in raster_list:
    year1 = extract_year(raster)
    label1 = extract_label(raster)

    # 遍历第二组文件
    for feature_class in feature_class_list:
        year2 = extract_year(feature_class)
        label2 = extract_label(feature_class)

        # 检查年份和标记号是否匹配
        if year1 == year2 and label1 == label2:
            # 处理匹配的两个文件
            print(str(year1)+'=='+str(year2)+' and '+str(label1)+'=='+str(label2))
            file1 = os.path.join(arcpy.env.workspace, raster)
            file2 = os.path.join(arcpy.env.workspace, feature_class)
            process_matching_files(file1, file2)
