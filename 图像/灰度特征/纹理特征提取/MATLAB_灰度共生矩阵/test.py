import os
import numpy as np
from skimage.feature import graycomatrix, graycoprops
from PIL import Image
import pandas as pd
import spectral.io.envi as envi
# 设置图像文件夹路径
data_folder = r'D:\红茶数据\test\裁剪后'

# 存储所有特征值的列表
all_contrast_values = []  # 对比度
all_correlation_values = []  # 相关性
all_energy_values = []  # 能量
all_inverse_difference_values = []  # 逆差矩阵

# 遍历所有图像文件
for filename in os.listdir(data_folder):
    if filename.endswith('.bmp'):  # 仅处理 BMP 格式的图像文件
        print(f'处理图像：{filename}')

        # 读取图像
        image_path = os.path.join(data_folder, filename)
        image = Image.open(image_path).convert('L')  # 转换为灰度图像
        image_array = np.array(image)

        # 计算GLCM
        glcm = greycomatrix(image_array, distances=[1], angles=[0], levels=256, symmetric=True, normed=True)

        # 计算特征
        contrast = greycoprops(glcm, 'contrast')[0, 0]
        correlation = greycoprops(glcm, 'correlation')[0, 0]
        energy = greycoprops(glcm, 'energy')[0, 0]
        inverse_difference = greycoprops(glcm, 'inverse_difference')[0, 0]

        # 将特征值添加到列表
        all_contrast_values.append(contrast)
        all_correlation_values.append(correlation)
        all_energy_values.append(energy)
        all_inverse_difference_values.append(inverse_difference)

# 创建 DataFrame 存储特征值
df = pd.DataFrame({
    '对比度 (Contrast)': all_contrast_values,
    '相关性 (Correlation)': all_correlation_values,
    '能量 (Energy)': all_energy_values,
    '逆差矩阵 (Inverse Difference)': all_inverse_difference_values
})

# 创建 Excel 文件名
output_folder = r'D:\红茶数据\test\纹理特征'
output_file = os.path.join(output_folder, 'texture_features.xlsx')

# 保存 DataFrame 到 Excel 文件
df.to_excel(output_file, index=False)

print(f'特征值已保存到 {output_file}')
print('处理完成。')
