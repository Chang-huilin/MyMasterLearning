import os
import numpy as np
from skimage.feature import graycomatrix, graycoprops
from PIL import Image
import pandas as pd
import spectral.io.envi as envi

def scale_and_quantize_image(image, levels):
    scaled_image = np.interp(image, (image.min(), image.max()), (0, levels-1))
    quantized_image = scaled_image.astype(np.uint8)
    return quantized_image

def process_band_data(band_data, levels=16):
    quantized_data = scale_and_quantize_image(band_data, levels)
    angles = [0, np.pi/4, np.pi/2, 3*np.pi/4]  # 0°, 45°, 90°, 135°
    contrasts, correlations, energies, inverse_diff_moments = [], [], [], []
    for angle in angles:
        glcm = graycomatrix(quantized_data, [1], [angle], levels=levels, symmetric=True, normed=True)
        contrasts.append(graycoprops(glcm, 'contrast')[0, 0])
        correlations.append(graycoprops(glcm, 'correlation')[0, 0])
        energies.append(graycoprops(glcm, 'energy')[0, 0])
        inverse_diff_moments.append(graycoprops(glcm, 'dissimilarity')[0, 0])
    return (np.mean(contrasts), np.mean(correlations), np.mean(energies), np.mean(inverse_diff_moments))

def process_folder(folder_path, bands, levels):
    hdr_files = [file for file in os.listdir(folder_path) if file.lower().endswith('.hdr')]
    if len(hdr_files) != 1:
        print(f'文件夹 {folder_path} 中未找到唯一的hdr文件')
        return None
    hdr_file_path = os.path.join(folder_path, hdr_files[0])
    matcha_hyp_data = envi.open(hdr_file_path)
    contrast_values, correlation_values, energy_values, inverse_diff_moment_values = [], [], [], []
    for i in range(bands):
        band_data = matcha_hyp_data.read_band(i)
        contrast, correlation, energy, inverse_diff_moment = process_band_data(band_data, levels)
        contrast_values.append(contrast)
        correlation_values.append(correlation)
        energy_values.append(energy)
        inverse_diff_moment_values.append(inverse_diff_moment)
    return contrast_values, correlation_values, energy_values, inverse_diff_moment_values

def main(data_folder, output_folder, bands, levels):
    for folder_name in os.listdir(data_folder):
        folder_path = os.path.join(data_folder, folder_name)
        if os.path.isdir(folder_path):
            print(f'处理文件夹：{folder_name}')
            results = process_folder(folder_path, bands, levels)
            if results:
                contrast_values, correlation_values, energy_values, inverse_diff_moment_values = results
                df = pd.DataFrame({
                    '对比度 (Contrast)': contrast_values,
                    '相关性 (Correlation)': correlation_values,
                    '能量 (Energy)': energy_values,
                    '逆差矩阵 (Inverse Difference Moment)': inverse_diff_moment_values
                })
                output_file = os.path.join(output_folder, f'{int(folder_name)+100:03d}.xlsx')
                df.to_excel(output_file, index=False)
                print(f'特征值已保存到 {output_file}')
    print('处理完成。')

# 参数设置
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\6足火后_processed'
output_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理5'
bands = 25
levels = 16  # 设置16个灰度级

main(data_folder, output_folder, bands, levels)
