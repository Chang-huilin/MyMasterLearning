import os
import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

def apply_pca(data, explained_variance_threshold=0.95):
    # 标准化数据
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(data)

    # 初始化PCA模型
    pca = PCA()

    # 对数据进行拟合
    pca.fit(scaled_data)

    # 计算累计方差贡献率
    explained_variance_ratio_cumsum = pca.explained_variance_ratio_.cumsum()

    # 选择特征值大于阈值的主成分数
    num_components = sum(explained_variance_ratio_cumsum <= explained_variance_threshold) + 1

    # 初始化PCA模型，设置选定的主成分数
    pca = PCA(n_components=num_components)

    # 对数据进行拟合和转换
    reduced_data = pca.fit_transform(scaled_data)

    return reduced_data

# 设置路径
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理'
output_folder = os.path.join(data_folder, 'pca')

# 如果输出文件夹不存在，创建它
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 遍历每个Excel文件
for file_name in os.listdir(data_folder):
    if file_name.endswith('.xlsx'):
        file_path = os.path.join(data_folder, file_name)

        # 读取Excel文件，跳过非数值的行
        df = pd.read_excel(file_path, header=None, skiprows=[0])  # 假设第一行是表头，跳过第一行
        
        df = df.T

        # 应用PCA并选择主成分
        reduced_data = apply_pca(df)

        # 保存降维后的数据到新的Excel文件
        output_file_path = os.path.join(output_folder, f'{file_name.replace(".xlsx", "_pca.xlsx")}')
        pd.DataFrame(reduced_data).to_excel(output_file_path, index=False)

print("PCA完成，并保存到", output_folder)
