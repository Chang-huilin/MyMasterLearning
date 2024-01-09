import os
import numpy as np
from PIL import Image
import pandas as pd
from scipy.stats import skew
import tkinter as tk
from tkinter import filedialog

def process_images():
    # 设置主文件夹路径
    main_folder = filedialog.askdirectory(title="选择主文件夹")

    # 设置保存结果的文件夹路径
    output_folder = filedialog.askdirectory(title="选择结果文件夹")

    # 遍历1到20的文件夹
    for folder_number in range(1, 21):
        # 构建子文件夹路径
        folder_path = os.path.join(main_folder, str(folder_number), '25个波段对应的图像\interestingspace')

        # 初始化 WL9 矩阵
        WL9 = np.zeros((25, 6))

        # 遍历25个波段
        for i in range(1, 26):
            # 构建文件路径
            filename = os.path.join(folder_path, f'{i}.bmp')

            # 读取图像
            A = Image.open(filename)

            # 将图像转为灰度
            A = A.convert('L')

            # 将图像转为 numpy 数组
            A_array = np.array(A)

            # 计算直方图
            p, _ = np.histogram(A_array.flatten(), bins=256, range=[0, 256])
            p = p / np.sum(A_array.size)

            # 计算统计矩
            mu = np.zeros(3)
            mu[0] = np.mean(p)
            mu[1] = np.std(p)
            mu[2] = skew(p)

            # 计算其他特征
            t = np.zeros(6)
            t[0] = mu[0]  # 平均值
            t[1] = mu[1] ** 0.5  # 标准差
            varn = mu[1] / (mu[0] ** 2)  # 平滑度
            t[2] = 1 - 1 / (1 + varn)
            t[3] = mu[2] / (mu[0] ** 3)  # 三阶矩
            t[4] = np.sum(p ** 2)  # 一致性
            t[5] = -np.sum(p * (np.log2(p + np.finfo(float).eps)))  # 熵

            WL9[i - 1, :] = t

        # 构建保存文件路径
        output_file = os.path.join(output_folder, f'{folder_number+20:03d}.xlsx')

        # 将结果保存到 Excel 文件
        df = pd.DataFrame(WL9, columns=['平均值', '标准差', '偏斜度', '平滑度', '三阶矩', '熵'])
        df.to_excel(output_file, index=False)

    print('处理完成。')

# 创建主窗口
root = tk.Tk()
root.title("图像处理工具")

# 添加按钮
run_button = tk.Button(root, text="运行图像处理", command=process_images)
run_button.pack(pady=10)

# 启动主循环
root.mainloop()
