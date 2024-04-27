import os
import numpy as np
from skimage.feature import graycomatrix, graycoprops
from PIL import Image
import pandas as pd
import spectral.io.envi as envi

# 设置高光谱数据文件夹路径
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\7碾茶_processed'

# 获取数据的维度
bands = 25  # 假设处理前25个波段

# 存储所有特征值的列表
all_contrast_values = [] # 对比度
all_correlation_values = [] # 相关性
all_energy_values = [] # 能量
all_inverse_difference_moment_values = [] # 逆差矩阵

# 遍历所有子文件夹
for folder_name in os.listdir(data_folder):
    folder_path = os.path.join(data_folder, folder_name)

    # 检查是否为文件夹
    if os.path.isdir(folder_path):
        print(f'处理文件夹：{folder_name}')

        # 寻找子文件夹内的hdr文件
        hdr_files = [file for file in os.listdir(folder_path) if file.lower().endswith('.hdr')]

        if len(hdr_files) == 1:
            hdr_file_path = os.path.join(folder_path, hdr_files[0])

            # 打开高光谱数据文件
            matcha_hyp_data = envi.open(hdr_file_path)

            # 逐个波段计算特征
            for i in range(bands):
                # 获取当前波段的数据
                band_data = matcha_hyp_data.read_band(i)  # 注意索引从1开始

                # 将数据缩放到0-255的范围（适用于uint8图像）
                scaled_data = np.interp(band_data, (band_data.min(), band_data.max()), (0, 255))

                # 创建 PIL Image 对象并转换为可写的 NumPy 数组
                image = Image.fromarray(scaled_data.astype(np.uint8)).convert("L")
                image_array = np.array(image)

                # 计算GLCM
                glcm = graycomatrix(image_array, [1], [0], symmetric=True, normed=True)

                # 计算特征
                contrast = graycoprops(glcm, 'contrast')[0, 0]
                correlation = graycoprops(glcm, 'correlation')[0, 0]
                energy = graycoprops(glcm, 'energy')[0, 0]
                inverse_difference_moment = graycoprops(glcm, 'dissimilarity')[0, 0]

                # 将特征值添加到列表
                all_contrast_values.append(contrast)
                all_correlation_values.append(correlation)
                all_energy_values.append(energy)
                all_inverse_difference_moment_values.append(inverse_difference_moment)

            print(f'文件夹 {folder_name} 中的所有波段已处理')
        else:
            print(f'文件夹 {folder_name} 中未找到唯一的hdr文件')

        # 创建 DataFrame 存储特征值
        df = pd.DataFrame({
            '对比度 (Contrast)': all_contrast_values,
            '相关性 (Correlation)': all_correlation_values,
            '能量 (Energy)': all_energy_values,
            '逆差矩阵 (Inverse Difference Moment)': all_inverse_difference_moment_values
        })

        # 创建 Excel 文件名
        output_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理3'
        output_file = os.path.join(output_folder, f'{int(folder_name)+120:03d}.xlsx')

        # 保存 DataFrame 到 Excel 文件
        df.to_excel(output_file, index=False)

        print(f'特征值已保存到 {output_file}')

print('处理完成。')
