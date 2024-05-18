import numpy as np
import matplotlib.pyplot as plt
from skimage.filters import threshold_otsu
from spectral import open_image

def process_and_display_multispectral_image(hdr_file_path, selected_bands, roi):
    # 读取多光谱图像
    img = open_image(hdr_file_path).load()
    
    # 获取图像的尺寸
    rows, cols, bands = img.shape

    # 裁剪图像
    x_min, y_min, x_max, y_max = roi
    img_cropped = img[y_min:y_max, x_min:x_max, :]

    # 获取裁剪后的图像尺寸
    rows_cropped, cols_cropped, _ = img_cropped.shape

    # 初始化 RGB 图像
    rgb_image = np.zeros((rows_cropped, cols_cropped, 3), dtype=float)

    # 将选定的特征波段映射到 RGB 颜色空间
    for i, band in enumerate(selected_bands):
        if i == 0:  # R 通道
            rgb_image[:, :, 0] = np.squeeze(img_cropped[:, :, band - 1])
        elif i == 1:  # G 通道
            rgb_image[:, :, 1] = np.squeeze(img_cropped[:, :, band - 1])
        elif i == 2:  # B 通道
            rgb_image[:, :, 2] = np.squeeze(img_cropped[:, :, band - 1])

    # 归一化到 [0, 1]
    rgb_image_normalized = (rgb_image - rgb_image.min()) / (rgb_image.max() - rgb_image.min())

    # 显示伪彩色图像
    plt.figure()
    plt.imshow(rgb_image_normalized)
    plt.title('Pseudo-color Image Using Selected Feature Bands')
    plt.axis('off')
    plt.show()

# 调用函数
selected_bands = [13, 12, 11]  # 至少需要三个波段来生成伪彩色图像
hdr_file_path = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\image_0000000000.hdr'
roi = (120, 25, 260, 165)  # 裁剪区域 (x_min, y_min, x_max, y_max)
process_and_display_multispectral_image(hdr_file_path, selected_bands, roi)
