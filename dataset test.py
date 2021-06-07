import numpy as np
import tensorflow as tf
from tensorflow import keras
#                   [1,2,3,4,5,6,7,8,9]
features = np.transpose(np.array([[1,2,3,4,5,6,7,8,9],[1,1,3,4,6,6,8,8,9]]))
labels = np.repeat(np.array([1,2,3]),3)

print("Features:", features)
print("Labels:", labels)

sequence_length=3




print('THE THING')

ds = tf.keras.preprocessing.timeseries_dataset_from_array(features, labels, sequence_length, 3, batch_size=1, shuffle=True)

for inputs, targets in ds:
  print("Input:", inputs.numpy(), "Target:", targets.numpy())