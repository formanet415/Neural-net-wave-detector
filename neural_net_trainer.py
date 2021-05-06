import os
#os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator

model = keras.Sequential(
    [
        keras.Input(shape=(128, 60, 1)),
        layers.Conv2D(32, 3, padding='valid', activation='relu'),
        layers.MaxPooling2D(pool_size=(2,2)),
        layers.Conv2D(64,3, activation='relu'),
        layers.MaxPooling2D(),
        layers.Conv2D(128,3, activation='relu'),
        layers.Flatten(),
        layers.Dense(64,activation='relu'),
        layers.Dense(2, activation='softmax'),
    ]
)


ds_train = tf.keras.preprocessing.image_dataset_from_directory(
    'dataset/',
    labels='inferred',
    label_mode='binary',
    color_mode='grayscale',
    batch_size=2,
    image_size=(128, 60),
    shuffle=True,
    seed=420,
    validation_split=0.1,
    subset='training'
)

ds_validation = tf.keras.preprocessing.image_dataset_from_directory(
    'dataset/',
    labels='inferred',
    label_mode='binary',
    color_mode='grayscale',
    batch_size=2,
    image_size=(128,60),
    shuffle=True,
    seed=420,
    validation_split=0.1,
    subset='validation'
)

print(model.summary())

model.compile(
    loss = keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer =keras.optimizers.Adagrad(lr=0.001),
    metrics=["accuracy"]
)

model.fit(ds_train, batch_size=64, epochs=100, verbose=2)
model.evaluate(ds_validation, batch_size=64, verbose=2)
model.save('saved_modelv2/')