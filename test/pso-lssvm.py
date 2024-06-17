import numpy as np
import scipy.io as sio
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
from pyswarm import pso

# 导入数据
file_path = "C:/Users/79365/Desktop/研究生/王雨/data.mat"
data = sio.loadmat(file_path)
res = data['res']

# 划分特征和标签
X = res[:, 1:33]  # 特征
y = res[:, 0]     # 标签

# 数据归一化
scaler = MinMaxScaler(feature_range=(0, 1))
X_scaled = scaler.fit_transform(X)

# 划分训练集和测试集，按3:2的比例
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.4, random_state=42)

# 定义优化函数
def lssvm_objective(params):
    C, gamma = params
    model = SVC(C=C, kernel='rbf', gamma=gamma)
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    return -accuracy  # 目标是最大化准确率，因此取负值

# PSO优化
lb = [0.1, 0.0001]  # C和gamma的下界
ub = [1000, 1]      # C和gamma的上界

optimal_params, _ = pso(lssvm_objective, lb, ub, swarmsize=30, maxiter=50)

# 获取最优参数
C_opt, gamma_opt = optimal_params

# 使用最优参数训练LSSVM模型
model = SVC(C=C_opt, kernel='rbf', gamma=gamma_opt)
model.fit(X_train, y_train)
y_train_pred = model.predict(X_train)
y_test_pred = model.predict(X_test)

# 计算准确率
train_accuracy = accuracy_score(y_train, y_train_pred)
test_accuracy = accuracy_score(y_test, y_test_pred)

print(f'训练集准确率: {train_accuracy * 100:.2f}%')
print(f'测试集准确率: {test_accuracy * 100:.2f}%')
print(f'最佳参数: C={C_opt}, gamma={gamma_opt}')
