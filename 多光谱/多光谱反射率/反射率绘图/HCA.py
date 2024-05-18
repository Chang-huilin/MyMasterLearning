import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.cluster import hierarchy

# 指定文件路径
file_path = r'C:\Users\79365\Desktop\图像-叶绿素\叶绿素\matlab数据\光谱.xlsx'

# 读取 Excel 文件中的数据
data = pd.read_excel(file_path)

# 设置行名为第一列，如果列名在数据文件中不存在，则可以省略该步骤
data = data.set_index(data.columns[0])

# 计算层次聚类并获取聚类结果
row_linkage = hierarchy.linkage(data, method='average', metric='euclidean')  # 使用平均链接和欧氏距离计算层次聚类
col_linkage = hierarchy.linkage(data.T, method='average', metric='euclidean')  # 对转置后的数据进行列层次聚类

# 绘制聚类热图并应用聚类结果
plt.figure(figsize=(12, 10))  # 设置图形大小
sns.clustermap(data, cmap='viridis', standard_scale=1, annot=False,
               
               row_cluster=True, col_cluster=False  ,  # 显示行聚类结果，隐藏列聚类结果
               row_linkage=row_linkage, col_linkage=col_linkage,  # 应用自定义的行和列链接
              
               figsize=(10, 8), cbar_pos=(0.95, 0.35, 0.03, 0.3), 
               cbar_kws={'label': 'Color Scale'})  # 设置树状图位置和大小
plt.xticks([])  # 隐藏x轴的数字
plt.yticks([])  # 隐藏y轴的数字
plt.show()

