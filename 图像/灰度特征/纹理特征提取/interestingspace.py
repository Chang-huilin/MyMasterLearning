import os
from PIL import Image

# 设置主文件夹路径
main_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\7碾茶_processed'

# 遍历1到20的文件夹
for folder_number in range(1, 21):
    # 构建子文件夹路径
    folder_path = os.path.join(main_folder, str(folder_number))

    # 构建interestingspace文件夹路径
    interestingspace_folder = os.path.join(folder_path, '25个波段对应的图像', 'interestingspace')
    os.makedirs(interestingspace_folder, exist_ok=True)

    # 遍历25个波段
    for i in range(1, 26):
        # 构建文件路径
        filename = os.path.join(folder_path, '25个波段对应的图像', f'{i}.bmp')

        # 读取图像
        A = Image.open(filename)

        # 裁剪图像
        B = A.crop((120, 25, 260, 165))  # 修改裁剪的区域

        # 构建保存文件路径
        save_path = os.path.join(interestingspace_folder, f'{i}.bmp')

        # 保存裁剪后的图像
        B.save(save_path)

        print(f'处理文件夹 {folder_number} 中的波段 {i}，保存到 {save_path}')

print('处理完成。')