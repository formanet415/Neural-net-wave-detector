import numpy as np
import tensorflow as tf
from tensorflow import keras

features = np.arange(1, 10)
labels = np.repeat(np.array([1,2,3]),3)

print("Features:", features)
print("Labels:", labels)

sequence_length=3




print('THE THING')

ds = tf.keras.preprocessing.timeseries_dataset_from_array(features, labels, sequence_length, 3, batch_size=1, shuffle=True)

for inputs, targets in ds:
  print("Input:", inputs.numpy(), "Target:", targets.numpy())