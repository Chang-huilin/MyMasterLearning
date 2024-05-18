from PIL import Image
import os

# 图像文件夹路径
folder_path = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像'

# 要合成的波段数
num_bands = 25

# 创建一个空白的合成图像
composite_image = Image.new('RGB', (num_bands, num_bands))

# 循环读取每个波段的图像，并将其拼接到合成图像上
for i in range(num_bands):
    # 每个波段图像的文件路径
    image_path = f"{folder_path}\\{i + 1}.bmp"  # 假设图像以1.png, 2.png, ..., 25.png命名

    # 打开图像
    band_image = Image.open(image_path)

    # 将波段图像粘贴到合成图像的相应位置
    composite_image.paste(band_image, (i, 0))

# 保存合成图像
composite_image_path = os.path.join(folder_path, 'composite_image.png')
composite_image.save(composite_image_path)

print("合成图像已保存为 composite_image.png")
