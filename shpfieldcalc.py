import arcpy
import os

# 要更新的字段名称和值来源字段名称
field_to_update = "PM25"
source_field = "PM25_1"

# 文件夹路径和文件后缀
folder_path = "E:/Code/data/gd/point/"
suffix = ".shp"

# 遍历文件夹中的所有 shp 文件
for filename in os.listdir(folder_path):
    if filename.endswith(suffix):
        # 构建完整路径并打开要素层和游标
        fc = os.path.join(folder_path, filename)
        fields = [field_to_update, source_field]
        with arcpy.da.UpdateCursor(fc, fields) as cursor:
            for row in cursor:
                # 将要更新的字段的值设置为值来源字段的值
                row[0] = row[1]
                cursor.updateRow(row)
