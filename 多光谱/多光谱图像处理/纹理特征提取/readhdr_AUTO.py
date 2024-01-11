import os
from PIL import Image
import numpy as np
import spectral.io.envi as envi

# 设置高光谱数据文件夹路径
data_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\7碾茶_processed'

# 获取数据的维度
bands = 25  # 假设处理前24个波段

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

            # 创建保存图像的文件夹（如果不存在）
            save_folder = os.path.join(folder_path, '25个波段对应的图像')
            os.makedirs(save_folder, exist_ok=True)

            # 逐个波段保存图像
            for i in range(bands):
                # 获取当前波段的数据
                band_data = matcha_hyp_data.read_band(i)  # 注意索引从1开始

                # 将数据缩放到0-255的范围（适用于uint8图像）
                scaled_data = np.interp(band_data, (band_data.min(), band_data.max()), (0, 255))

                # 创建 PIL Image 对象
                image = Image.fromarray(scaled_data.astype(np.uint8))

                # 构建保存文件路径
                save_path = os.path.join(save_folder, f'{i+1}.bmp')

                # 保存图像为 BMP 格式
                image.save(save_path)

                print(f'保存波段 {i} 到 {save_path}')

            print(f'文件夹 {folder_name} 中的所有波段已保存')
        else:
            print(f'文件夹 {folder_name} 中未找到唯一的hdr文件')

print('处理完成。')
