import scipy.io
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier

# Step 1: 加载数据
mat = scipy.io.loadmat('C:/Users/79365/Desktop/研究生/王雨/data.mat')
data = mat['res']
df = pd.DataFrame(data)

# Step 2: 数据预处理
X = df.iloc[:, 1:]  # 特征从第2列到最后一列
y = df.iloc[:, 0]   # 类别在第一列

# 处理缺失值，例如用每列的均值填充
X.fillna(X.mean(), inplace=True)

# 可选：对特征进行标准化或缩放
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Step 3: 分割数据集为训练集和验证集
X_train, X_validation, y_train, y_validation = train_test_split(X, y, test_size=0.25, random_state=1)

# Step 4: 初始化决策树分类器并训练模型
tree = DecisionTreeClassifier(random_state=3)
tree.fit(X_train, y_train)

# 计算训练集上的准确率（仅供演示）
train_accuracy = tree.score(X_train, y_train)
print(f"训练集准确率: {train_accuracy:.4f}")

# 计算验证集上的准确率
validation_accuracy = tree.score(X_validation, y_validation)
print(f"验证集准确率: {validation_accuracy:.4f}")
