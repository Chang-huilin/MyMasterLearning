import os
import numpy as np
from skimage.feature import graycomatrix, graycoprops
from PIL import Image
import cv2
import pandas as pd
from matplotlib import pyplot as plt
import spectral.io.envi as envi

def scale_and_quantize_image(image, levels):
    # 缩放图像灰度值到 [0, levels-1] 之间
    scaled_image = np.interp(image, (image.min(), image.max()), (0, levels-1))
    quantized_image = scaled_image.astype(np.uint8)
    return quantized_image

def process_band_data(band_data, levels=16):
    # 缩放和量化图像
    quantized_data = scale_and_quantize_image(band_data, levels)
    
    # 计算GLCM
    glcm = graycomatrix(quantized_data, [1], [0], levels=levels, symmetric=True, normed=True)#计算距离为1和2，角度为0度、45度、90度和135度的GLCM。
    
    # 计算特征
    contrast = graycoprops(glcm, 'contrast')[0, 0]
    correlation = graycoprops(glcm, 'correlation')[0, 0]
    energy = graycoprops(glcm, 'energy')[0, 0]
    homogeneity = graycoprops(glcm, 'homogeneity')[0, 0]
    
    return contrast, correlation, energy, homogeneity
    #distances = [1, 2]
    #angles = [0, np.pi/4, np.pi/2, 3*np.pi/4]
    #glcm = graycomatrix(image_array, distances, angles, symmetric=True, normed=True)

def process_folder(folder_path, bands, levels):
    hdr_files = [file for file in os.listdir(folder_path) if file.lower().endswith('.hdr')]
    if len(hdr_files) != 1:
        print(f'文件夹 {folder_path} 中未找到唯一的hdr文件')
        return None
    hdr_file_path = os.path.join(folder_path, hdr_files[0])
    matcha_hyp_data = envi.open(hdr_file_path)
    contrast_values, correlation_values, energy_values, homogeneity_values = [], [], [], []
    for i in range(bands):
        band_data = matcha_hyp_data.read_band(i)
        contrast, correlation, energy, homogeneity = process_band_data(band_data, levels)
        contrast_values.append(contrast)
        correlation_values.append(correlation)
        energy_values.append(energy)
        homogeneity_values.append(homogeneity)
    return contrast_values, correlation_values, energy_values, homogeneity_values

def main(data_folder, output_folder, bands, levels):
    for folder_name in os.listdir(data_folder):
        folder_path = os.path.join(data_folder, folder_name)
        if os.path.isdir(folder_path):
            print(f'处理文件夹：{folder_name}')
            results = process_folder(folder_path, bands, levels)
            if results:
                contrast_values, correlation_values, energy_values, homogeneity_values = results
                df = pd.DataFrame({
                    '对比度 (Contrast)': contrast_values,
                    '相关性 (Correlation)': correlation_values,
                    '能量 (Energy)': energy_values,
                    '均匀性 (Homogeneity)': homogeneity_values
                })
                output_file = os.path.join(output_folder, f'{int(folder_name)+120:03d}.xlsx')
                df.to_excel(output_file, index=False)
                print(f'特征值已保存到 {output_file}')
    print('处理完成。')

# 参数设置
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\7碾茶_processed'
output_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理5'
bands = 25
levels = 16  # 设置16个灰度级

main(data_folder, output_folder, bands, levels)
