import os
from PIL import Image

# 设置主文件夹路径
main_folder = r'D:\红茶数据\all3'

# 遍历主文件夹中的 BMP 图像
for filename in os.listdir(main_folder):
    if filename.endswith('.bmp'):
        # 读取图像
        A = Image.open(os.path.join(main_folder, filename))

        # 裁剪图像
        crop_region = (440, 250, 1200, 950)  # 定义裁剪的区域 (left, top, right, bottom)
        B = A.crop(crop_region)

        # 构建保存文件路径
        save_path = os.path.join(main_folder, '裁剪后', filename)

        # 确保保存路径存在
        os.makedirs(os.path.dirname(save_path), exist_ok=True)

        # 保存裁剪后的图像
        B.save(save_path)

        print(f'处理文件 {filename}，保存到 {save_path}')

print('处理完成。')
