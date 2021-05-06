##
##  BASICALLY THE SAME AS WAVE_FINDER.PY, EXCEPT IT SAVES EVERYTHING TO .CSV
##
import os
#os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from PIL import Image
import numpy as np
from pathlib import Path
import csv
from sklearn.metrics import confusion_matrix
import math

loaded_model = keras.models.load_model('saved_modelv2')
print(loaded_model.summary())

values = []

directory = r'converted_tswf_spectra/'
paths = sorted(Path(directory).iterdir(), key=os.path.getmtime)
for filename in paths:
    if str(filename).endswith(".jpg") or str(filename).endswith(".png"):
        #print(os.path.join(directory, filename))
        #evaluating         Input(shape=(128, 60, 1))

        image = tf.keras.preprocessing.image.load_img(str(filename), color_mode='grayscale')
        input_arr = keras.preprocessing.image.img_to_array(image)
        input_arr = np.array([input_arr])  # Convert single image to a batch.
        predictions = loaded_model.predict(input_arr)
        #print(predictions)
        #if (0.1<predictions[0,1]):
            #print(str(filename) + ' %f chance of being ESW' %predictions[0,1])
            #print()
        #print(loaded_model(input_arr))

        values.append((predictions[0,1]))
    else:
        print('something happened')
        continue

with open('data/ESW_probabilities.csv', mode='w') as csv_file:
    data_writer = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    data_writer.writerow(values)
    #data_writer.writerow(checked)

#pred = values
#true = checked

#confusion = confusion_matrix(true, pred)
#print(confusion)


