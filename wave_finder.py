import os
#os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from PIL import Image
import numpy as np

loaded_model = keras.models.load_model('saved_model')
print(loaded_model.summary())

directory = r'converted_spectra/'
for filename in os.listdir(directory):
    if filename.endswith(".jpg") or filename.endswith(".png"):
        print(os.path.join(directory, filename))
        #evaluating         Input(shape=(128, 60, 1))

        image = tf.keras.preprocessing.image.load_img(os.path.join('converted_spectra', filename), color_mode='grayscale')
        input_arr = keras.preprocessing.image.img_to_array(image)
        input_arr = np.array([input_arr])  # Convert single image to a batch.
        predictions = loaded_model.predict(input_arr)
        print(predictions)
        #print(loaded_model(input_arr))
    else:
        continue