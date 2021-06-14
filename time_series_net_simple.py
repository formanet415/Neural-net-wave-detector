# Dataset import
import os
import pickle
import numpy as np
# Net import
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from sklearn.model_selection import train_test_split


def load_pickle(names, dirname):
    for n in names:
        if 'label' in n:
            with open (os.path.join(dirname, n), 'rb') as f:
                if 'y' not in locals():
                    y = pickle.load(f)
                else:
                    y = np.append(y, pickle.load(f))

    for n in names:
        if 'data' in n:
            with open (os.path.join(dirname, n), 'rb') as f:
                if 'x' not in locals():
                    x = pickle.load(f)
                else:
                    x = np.append(x, pickle.load(f), axis=1)
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
x = layers.Dense(4096, activation='relu')(inputs)
x = layers.Dense(2048, activation='relu')(x)
x = layers.Dense(1024, activation='relu')(x)
x = layers.Dense(512, activation='relu')(x)
outputs = layers.Dense(3, activation='softmax')(x)

model = keras.Model(inputs=inputs, outputs=outputs)
model.compile(
    loss=keras.losses.SparseCategoricalCrossentropy(from_logits=False),
    optimizer=keras.optimizers.Adagrad(lr=0.01),
    metrics=["accuracy"],
)

model.fit(x_train, y_train, batch_size=400, epochs=100, verbose=2)
model.evaluate(x_validate, y_validate, batch_size=10, verbose=2)

model.save('time_series_simple/')
