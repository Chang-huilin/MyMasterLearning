from skimage import feature, color
import matplotlib.pyplot as plt
from skimage import io

# 读取图像
image_path = 'your_image_path.jpg'  # 替换为实际图像路径
image = io.imread(image_path)

# 将图像转换为灰度
gray_image = color.rgb2gray(image)

# 计算LBP图像
radius = 1
n_points = 8 * radius
lbp_image = feature.local_binary_pattern(gray_image, n_points, radius, method='uniform')

# 显示原始图像和LBP图像
fig, axes = plt.subplots(1, 2, figsize=(8, 4))
ax = axes.ravel()

ax[0].imshow(gray_image, cmap=plt.cm.gray)
ax[0].set_title('Original Image')

ax[1].imshow(lbp_image, cmap=plt.cm.gray)
ax[1].set_title('LBP Image')

plt.show()
