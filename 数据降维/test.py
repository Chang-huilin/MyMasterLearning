import numpy as np
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

# 生成示例数据
np.random.seed(42)  # 为了可重复性
X = np.random.rand(120, 1)  # 120x1的数据

# 标签每20行一个阶段
labels = np.repeat(np.arange(1, 7), 20)  # 生成阶段标签

# 使用t-SNE进行降维
tsne = TSNE(n_components=2, random_state=42)
X_tsne = tsne.fit_transform(X)

# 绘图
plt.figure(figsize=(8, 6))
for label in np.unique(labels):
    indices = labels == label
    plt.scatter(X_tsne[indices, 0], X_tsne[indices, 1], label=f'Stage {label}', alpha=0.7)

plt.legend()
plt.title('t-SNE Visualization')
plt.xlabel('t-SNE feature 1')
plt.ylabel('t-SNE feature 2')
plt.show()
