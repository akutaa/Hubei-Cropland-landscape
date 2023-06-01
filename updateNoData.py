# -*- coding: UTF-8 -*-
# Author: ChatGPT Mar 14 Version
import arcpy
import os

# 包含shp文件的文件夹路径
folder_path = "E:/Code/data/gd/point/"

# 要更新的字段名称
field_name = "SOIL"

# 遍历文件夹中的所有shp文件
for filename in os.listdir(folder_path):
    if filename.endswith(".shp"):
        shp_path = os.path.join(folder_path, filename)

        # 打开要素层和游标
        with arcpy.da.UpdateCursor(shp_path, field_name) as cursor:
            # 计算字段的均值
            values = [row[0] for row in cursor if row[0] != -9999]
            mean_value = sum(values) / len(values)

            # 重新打开游标以遍历所有记录
            cursor.reset()
            for row in cursor:
                # 如果值为-9999，则将其更改为均值
                if row[0] == -9999:
                #if row[0] == 0:
                    row[0] = mean_value
                    #row[0] = 23110
                    cursor.updateRow(row)

