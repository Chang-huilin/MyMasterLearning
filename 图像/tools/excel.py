import os
import pandas as pd

# 文件夹路径
folder_path = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理5'

# 保存结果的Excel文件名
output_excel = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\平均值结果.xlsx'

# 列出文件夹中所有的Excel文件
excel_files = [f for f in os.listdir(folder_path) if f.endswith('.xlsx')]

# 存放所有文件的平均值
all_averages = []

# 读取每个Excel文件
for file in excel_files:
    file_path = os.path.join(folder_path, file)
    
    # 读取Excel文件
    df = pd.read_excel(file_path, header=None)
    
    # 取每个文件的2-26行，计算平均值
    average = df.iloc[1:26, 0:4].mean()  # 假设要取第一列（Python中索引从0开始）
    
    # 将结果保存到列表中
    all_averages.append(average)

# 创建包含平均值的DataFrame
result_df = pd.DataFrame({'文件名': excel_files, '平均值': all_averages})

# 将结果保存到新的Excel文件中
result_df.to_excel(output_excel, index=False)

print(f'平均值已保存到 {output_excel}')
