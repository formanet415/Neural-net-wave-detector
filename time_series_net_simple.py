# Dataset import
import math
import os
import pickle
import numpy as np
# Net import
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from sklearn.model_selection import train_test_split

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"


def load_pickle(names, dirname):
    for n in names:
        if 'label' in n:
            with open (os.path.join(dirname, n), 'rb') as f:
                if 'empty' not in n:
                    if 'y' not in locals():
                        y = pickle.load(f)
                    else:
                        y = np.append(y, pickle.load(f))
                else:
                    y_load = pickle.load(f)
                    l = math.floor(y_load.shape[0] / 4)
                    y_load = y_load[0:l]
                    if 'y' not in locals():
                        y = y_load
                    else:
                        y = np.append(y, y_load)

    for n in names:
        if 'data' in n:
            with open (os.path.join(dirname, n), 'rb') as f:
                if 'empty' not in n:
                    if 'x' not in locals():
                        x = pickle.load(f)
                    else:
                        x = np.append(x, pickle.load(f), axis=1)
                else:
                    x_load = pickle.load(f)
                    l = math.floor(x_load.shape[1]/4)
                    if 'x' not in locals():
                        x = x_load[:, 0:len, :]
                    else:
                        x = np.append(x, x_load[:, 0:l, :], axis=1)
    x = reshape(x)
    return x, y

def reshape(x):
    newx = np.zeros([len(x[0, :, 0]), 4096*2])
    for i in range(len(x[0, :, 0])):
        newx[i,:] = np.reshape(x[:, i, :],-1)
    return(newx)

pickle_dirname = 'jar of pickles'
pickle_names = os.listdir(pickle_dirname)
[x, y] = load_pickle(pickle_names, pickle_dirname)

x_train, x_validate = train_test_split(x, test_size=0.05, random_state=421)
y_train, y_validate = train_test_split(y, test_size=0.05, random_state=421)

print('Loaded data')

inputs = keras.Input(shape=(4096*2))
#x = layers.Dense(2048, activation='relu')(inputs)
x = layers.Dense(800, activation='relu')(inputs)
x = layers.Dense(300, activation='relu')(x)
outputs = layers.Dense(3, activation='softmax')(x)


model = keras.Model(inputs=inputs, outputs=outputs)
model.compile(
    loss=keras.losses.SparseCategoricalCrossentropy(from_logits=False),
    optimizer=tf.keras.optimizers.SGD(learning_rate=0.01),
    metrics=["accuracy"],
)

model.fit(x_train, y_train, batch_size=400, epochs=100, verbose=2)
model.evaluate(x_validate, y_validate, batch_size=10, verbose=2)

print("Empty to non empty training ration is: %f" %((np.sum(y_train==0))/(y_train.shape[0])))
print("Empty to non empty validate ration is: %f" %((np.sum(y_validate==0))/(y_validate.shape[0])))


model.save('time_series_simple/')
