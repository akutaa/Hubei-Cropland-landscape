import arcpy
import os

# 文件夹路径和文件后缀
folder_path = "E:/Code/data/gd/point/"
suffix = ".shp"

# 遍历文件夹中的所有 shp 文件
for filename in os.listdir(folder_path):
    if filename.endswith(suffix):
        # 构建完整路径并打开要素层
        fc = os.path.join(folder_path, filename)
        
        # 将属性表导出为 Excel 文件
        out_excel = os.path.splitext(fc)[0] + ".xlsx"
        arcpy.conversion.TableToExcel(fc, out_excel)
