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

    # 初始化二值化处理后的图像
    binary_image = np.zeros((rows_cropped, cols_cropped, len(selected_bands)), dtype=bool)

    # 对特征波段进行二值化处理
    for i, band in enumerate(selected_bands):
        band_image = img_cropped[:, :, band - 1]  
        threshold = threshold_otsu(band_image)
        binary_image[:, :, i] = np.squeeze((band_image > threshold).astype(bool))
        

    # 对其他波段进行处理，将背景像素的光谱设为零
    processed_img = np.copy(img_cropped)
    for i in range(bands):
        if (i + 1) not in selected_bands:
            processed_img[:, :, i][binary_image.all(axis=2)] = 0


    # 将三维光谱数据转换为二维光谱数据
    img_2d = processed_img.reshape((rows_cropped * cols_cropped, bands))

    # 显示特征波段的二值化图像
    fig, axes = plt.subplots(1, len(selected_bands), figsize=(15, 5))
    for i, ax in enumerate(axes):
        ax.imshow(binary_image[:, :, i], cmap='gray')
        ax.set_title(f'Band {selected_bands[i]}')
        ax.axis('off')
    plt.show()

    # 生成伪彩色图像，使用前三个特征波段
    if len(selected_bands) >= 3:
        pseudo_color_image = np.stack([
            processed_img[:, :, selected_bands[0] - 1],
            processed_img[:, :, selected_bands[1] - 1],
            processed_img[:, :, selected_bands[2] - 1]
        ], axis=-1)
    else:
        raise ValueError("Selected bands should contain at least 3 bands for pseudo-color image generation")

    pseudo_color_image = (255 * (pseudo_color_image - pseudo_color_image.min()) / 
                          (pseudo_color_image.max() - pseudo_color_image.min())).astype(np.uint8)

    # 显示伪彩色图像
    plt.figure()
    plt.imshow(pseudo_color_image)
    plt.title('Pseudo-color Image Using Selected Feature Bands')
    plt.axis('off')
    plt.show()

    # 保存二维光谱数据
    np.save('processed_spectral_data.npy', img_2d)
    print('二维光谱数据大小:', img_2d.shape)

# 调用函数
selected_bands = [13, 12, 11, 14, 15]
hdr_file_path = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\image_0000000000.hdr'
roi = (120, 25, 260, 165)  # 裁剪区域 (x_min, y_min, x_max, y_max)
process_and_display_multispectral_image(hdr_file_path, selected_bands, roi)
