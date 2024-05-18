import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import zscore
from tsne import TSNE

# 生成示例数据
X = np.random.randn(140, 25)  # 生成随机数据

# 数据标准化
Z = zscore(X)

# 划分数据为 7 个阶段
num_stages = 7
stage_size = int(np.ceil(Z.shape[0] / num_stages))  # 每个阶段的样本数量

# 使用 t-SNE 进行降维
num_dims = 2  # 指定降维后的维度为 2
perplexity = 30  # t-SNE 参数：perplexity
tsne_result = TSNE(n_components=num_dims, perplexity=perplexity).fit_transform(Z)

# 绘制 t-SNE 结果，每个阶段用不同颜色表示
plt.figure()
plt.hold('on')
colors = plt.cm.parula(np.linspace(0, 1, num_stages))  # 生成不同阶段的颜色

for i in range(num_stages):
    start_idx = (i - 1) * stage_size
    end_idx = min(i * stage_size, Z.shape[0])
    plt.scatter(tsne_result[start_idx:end_idx, 0], tsne_result[start_idx:end_idx, 1], c=colors[i], s=50)

plt.xlabel('t-SNE Dimension 1')
plt.ylabel('t-SNE Dimension 2')
plt.title('t-SNE Plot with Different Stages')

# 添加图例显示不同阶段
legend_labels = [f'Stage {i + 1}' for i in range(num_stages)]
plt.legend(legend_labels)
plt.show()
