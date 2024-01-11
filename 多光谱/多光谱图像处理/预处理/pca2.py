import os
import pandas as pd

# 设置路径
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理2'
output_folder = os.path.join(data_folder, '平均')

# 如果输出文件夹不存在，创建它
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 初始化一个DataFrame来存储平均值
average_df = None

# 遍历每个Excel文件
for file_name in os.listdir(data_folder):
    if file_name.endswith('.xlsx'):
        file_path = os.path.join(data_folder, file_name)

        # 读取Excel文件，跳过非数值的行
        df = pd.read_excel(file_path, header=None, skiprows=[0])  # 假设第一行是表头，跳过第一行

        # 计算每列的平均值
        column_means = df.mean(axis=0)

        # 如果是第一个文件，直接将平均值赋给average_df
        if average_df is None:
            average_df = pd.DataFrame(column_means).T
        else:
            # 否则，将平均值添加到average_df中
            average_df = pd.concat([average_df, pd.DataFrame(column_means).T], ignore_index=True)

# 保存平均值到新的Excel文件
output_file_path = os.path.join(output_folder, '平均.xlsx')
average_df.to_excel(output_file_path, index=False)

print("平均值已计算，并保存到", output_file_path)
