from hyperopt import Trials, STATUS_OK, tpe
from hyperas import optim
from hyperas.distributions import choice, uniform
from keras.models import Sequential
from keras.layers import Dense, Dropout
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import numpy as np

def data():
    # 生成一些示例数据（这里使用随机生成的数据）
    np.random.seed(42)
    X = np.random.rand(100, 10)
    y = np.sum(X, axis=1) + np.random.normal(0, 0.1, 100)  # 添加一些噪声

    # 划分训练集和测试集
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    return X_train, y_train, X_test, y_test

def model(X_train, y_train, X_test, y_test):
    model = Sequential()

    model.add(Dense({{choice([32, 64, 128])}}, activation='relu', input_shape=(X_train.shape[1],)))
    model.add(Dropout({{uniform(0, 1)}}))

    model.add(Dense({{choice([64, 128, 256])}}, activation='relu'))
    model.add(Dropout({{uniform(0, 1)}}))

    model.add(Dense(1, activation='linear'))

    model.compile(loss='mean_squared_error', metrics=['mean_squared_error'], optimizer='adam')

    result = model.fit(X_train, y_train, epochs=10, batch_size={{choice([64, 128])}}, validation_split=0.2, verbose=0)

    validation_mse = np.min(result.history['val_mean_squared_error'])
    return {'loss': validation_mse, 'status': STATUS_OK, 'model': model}

best_run, best_model = optim.minimize(model=model, data=data, algo=tpe.suggest, max_evals=5, trials=Trials(), notebook_name='your_notebook_name')

X_train, y_train, X_test, y_test = data()
y_pred = best_model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print("Mean Squared Error on Test Data:", mse)
