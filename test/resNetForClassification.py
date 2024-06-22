import pandas as pd
from sklearn.model_selection import train_test_split
import tensorflow as tf
from tensorflow.keras.layers import Input, Dense, Conv2D, BatchNormalization, Activation, Add, GlobalAveragePooling2D, MaxPooling2D # type: ignore
from tensorflow.keras.models import Model # type: ignore
from tensorflow.keras.utils import to_categorical # type: ignore
import numpy as np

# 定义一个更深的残差块
def deep_resnet_block(inputs, filters, kernel_size=3, stride=1):
    x = Conv2D(filters, kernel_size=kernel_size, strides=stride, padding='same')(inputs)
    x = BatchNormalization()(x)
    x = Activation('relu')(x)
    
    x = Conv2D(filters, kernel_size=kernel_size, strides=1, padding='same')(x)
    x = BatchNormalization()(x)
    
    shortcut = Conv2D(filters, kernel_size=1, strides=stride, padding='same')(inputs)
    shortcut = BatchNormalization()(shortcut)
    
    x = Add()([x, shortcut])
    x = Activation('relu')(x)
    
    return x

# 定义更深的ResNet模型
def create_deep_resnet(input_shape, num_classes):
    inputs = Input(shape=input_shape)
    
    x = Conv2D(64, kernel_size=7, strides=2, padding='same')(inputs)
    x = BatchNormalization()(x)
    x = Activation('relu')(x)
    x = MaxPooling2D(pool_size=3, strides=2, padding='same')(x)
    
    x = deep_resnet_block(x, filters=64)
    x = deep_resnet_block(x, filters=128, stride=2)
    x = deep_resnet_block(x, filters=256, stride=2)
    x = deep_resnet_block(x, filters=512, stride=2)
    
    x = GlobalAveragePooling2D()(x)
    x = Dense(512, activation='relu')(x)
    x = Dense(num_classes, activation='softmax')(x)
    
    model = Model(inputs, x)
    return model

# 从Excel加载数据
file_path = "C:\\Users\\79365\\Desktop\\研究生\\王雨\\增加变量后0.xlsx"
data = pd.read_excel(file_path, header=None)

# 分离特征和标签
X = data.iloc[:, 1:].values
y = data.iloc[:, 0].values

# 将类别索引从1到7转换为从0到6
y = y - 1

# 将标签转换为独热编码
num_classes = len(np.unique(y))
y = to_categorical(y, num_classes=num_classes)

# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 调整输入数据的形状以适应更深的ResNet模型
X_train = X_train.reshape(-1, X_train.shape[1], 1, 1)
X_test = X_test.reshape(-1, X_test.shape[1], 1, 1)
input_shape = (X_train.shape[1], 1, 1)

# 创建更深的ResNet模型
model = create_deep_resnet(input_shape, num_classes)

# 编译模型
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# 输出模型结构
model.summary()

# 训练模型
model.fit(X_train, y_train, epochs=20, batch_size=32, validation_data=(X_test, y_test))

# 评估模型
loss, accuracy = model.evaluate(X_test, y_test)
print(f"测试集损失: {loss}")
print(f"测试集准确率: {accuracy}")


from sklearn.metrics import confusion_matrix
# 在测试集上进行预测
y_pred = model.predict(X_test)
y_pred_classes = np.argmax(y_pred, axis=1)
y_true = np.argmax(y_test, axis=1)
# 计算混淆矩阵
conf_matrix = confusion_matrix(y_true, y_pred_classes)

print("混淆矩阵：")
print(conf_matrix)