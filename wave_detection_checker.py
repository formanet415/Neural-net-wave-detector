import os
#os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from PIL import Image
import numpy as np

loaded_model = keras.models.load_model('saved_modelv2')
print(loaded_model.summary())

directory = r'converted_spectra/'
for filename in [155,305,350,423,483,484,497,538,567,597,620,653,725,726,779,811,827,834,842,853,855,862,863,871,874,880,1055,1120,1135,1148,1205,1265,1270,1286,1294,1431,1437,1438,1465,1473,1489,1507,1543,1729,1736,1806,1844,1854,1888,1899,2028,2034,2080,2116,2153,2155,2197,2292,2334,2401,2423,2434]:#os.listdir(directory):
    #if filename.endswith(".jpg") or filename.endswith(".png"):
    try:
        print(os.path.join(directory, '%d.png' % filename))
        #evaluating         Input(shape=(128, 60, 1))

        image = tf.keras.preprocessing.image.load_img(os.path.join(directory, '%d.png' % filename), color_mode='grayscale')
        input_arr = keras.preprocessing.image.img_to_array(image)
        input_arr = np.array([input_arr])  # Convert single image to a batch.
        predictions = loaded_model.predict(input_arr)
        print(predictions)
        #print(loaded_model(input_arr))
    except:
        continue