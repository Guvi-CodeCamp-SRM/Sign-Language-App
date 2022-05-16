import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix,accuracy_score, classification_report, multilabel_confusion_matrix
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPool2D, Flatten, Dense, Dropout, BatchNormalization
import seaborn as sns
import warnings 

warnings.filterwarnings('ignore')

import cv2
import csv 
train = pd.read_csv(r"C:\Users\HP\Desktop\train\sign_mnist_train\sign_mnist_train.csv")
test = pd.read_csv(r"C:\Users\HP\Desktop\test\sign_mnist_test\sign_mnist_test.csv")

train_df_original = train.copy()

val_index = int(train.shape[0]*0.2)

train_df = train_df_original.iloc[val_index:]
val_df = train_df_original.iloc[:val_index]

y = np.array(train_df['label'])
X = np.array(train_df.drop(columns='label'))

y_train = pd.get_dummies(y)

y_val = val_df['label']
X_val = val_df.drop(columns="label",axis=1)
y_val = pd.get_dummies(y_val)

X_val = pd.DataFrame(X_val).values.reshape(X_val.shape[0] ,28, 28, 1)

X_train = pd.DataFrame(X).values.reshape(X.shape[0] ,28, 28, 1)

generator = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale=1./255,
    rotation_range=10,
    zoom_range=0.10,
    width_shift_range=0.1,
    height_shift_range=0.1,
    shear_range=0.1,
    horizontal_flip=False,
    fill_mode="nearest"
)

X_train_flow = generator.flow(X_train, y_train, batch_size=32)

X_val_flow = generator.flow(X_val, y_val, batch_size=32)

model = Sequential()

model.add(Conv2D(filters=32,  kernel_size=(3,3), activation="relu", input_shape=(28,28,1)))
model.add(MaxPool2D((2,2),padding='SAME'))
model.add(Dropout(rate=0.2))


model.add(Conv2D(filters=64,  kernel_size=(3,3), activation="relu", input_shape=(28,28,1)))
model.add(MaxPool2D((2,2),padding='SAME'))
model.add(Dropout(rate=0.2))


model.add(Conv2D(filters=521,  kernel_size=(3,3), activation="relu", input_shape=(28,28,1)))
model.add(MaxPool2D((2,2),padding='SAME'))
model.add(Dropout(rate=0.2))

model.add(Flatten())
model.add(Dense(units=521, activation="relu"))
model.add(Dense(units=256, activation="relu"))
model.add(Dropout(0.5))
model.add(Dense(units=24, activation="softmax"))


model.compile(loss="categorical_crossentropy", optimizer='adam',  metrics=["accuracy"])
model.summary()

learning_rate_reduction = tf.keras.callbacks.ReduceLROnPlateau(
    monitor='val_accuracy', patience = 2, verbose=1,factor=0.5, min_lr=0.00001
)

history = model.fit(
    X_train_flow,
    validation_data=X_val_flow,
    # epochs=100,
    epochs=25,
    callbacks=[
               tf.keras.callbacks.EarlyStopping(
                   monitor='val_loss',
                   patience=5,
                   restore_best_weights=True
                   ),
      learning_rate_reduction
    ])

y_test = np.array(test['label'])
X_test = np.array(test.drop(columns='label'))

y_test = pd.get_dummies(y_test)
X_test = pd.DataFrame(X_test).values.reshape(X_test.shape[0] ,28, 28, 1)

# X_test_flow = generator.flow(X_test, y_test, batch_size=32)
# X_test.shape,X_train.shape

# y_test = pd.get_dummies(y_test)

from sklearn.metrics import classification_report

# predictions
pred = model.predict(X_test)

y_pred = np.argmax(pred,axis=1)
y_test = np.argmax(y_test.values,axis=1)

acc = accuracy_score(y_test,y_pred)

# # Display the results
print(f'## {acc*100:.2f}% accuracy on the test set')

model.save("sign_lang_det.h5")

from keras import models
model = models.load_model("sign_lang_det.h5")

cap = cv2.VideoCapture(0)

while True:
  ret, frame = cap.read()
  #print(ret)
  roi = frame[100:400, 320:620]
  cv2.imshow('roi', roi)
  roi = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
  roi = cv2.resize(roi, (28,28), interpolation = cv2.INTER_AREA)

  cv2.imshow('roi sacled and gray', roi)
  copy = frame.copy()
  cv2.rectangle(copy, (320, 100), (620, 400), (255,0,0), 5)

  roi = roi.reshape(1, 28, 28, 1)

  result = model.predict(roi, 1, verbose = 0)[0]
  # cv2.putText(copy, result,(300, 100), cv2.FONT_HERSHEY_COMPLEX, 2, (0, 255, 0), 2)
  cv2.putText(copy, str(np.argmax(result)), (300, 100), cv2.FONT_HERSHEY_COMPLEX, 2, (0, 255, 0), 2)
  cv2.imshow('frame', copy)

  if cv2.waitKey(10) & 0xFF == ord('d'):
    break

cap.release()
cv2.destroyAllWindows()
