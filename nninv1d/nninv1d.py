# -*- coding: utf-8 -*-
"""
Created on Tue Mar  7 15:43:18 2017

@author: hanar
"""

import time
import numpy as np
import os
# from keras.utils import np_utils
gpu_id = 1
import tensorflow as tf
print(tf.__version__)
if tf.__version__ >= "2.1.0":
    physical_devices = tf.config.list_physical_devices('GPU')
    tf.config.list_physical_devices('GPU')
    tf.config.set_visible_devices(physical_devices[gpu_id], 'GPU')
    tf.config.experimental.set_memory_growth(physical_devices[gpu_id], True)

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation, Dropout
from tensorflow.keras.optimizers import SGD
from tensorflow.keras.callbacks import ModelCheckpoint
from tensorflow.keras.callbacks import TensorBoard
from tensorflow.keras.models import load_model
from tensorflow.distribute import MirroredStrategy
#from keras.utils.visualize_util import plot
import tensorflow.keras.callbacks
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt

#Global variables for normalizing parameters
max_x = 1.0
min_x = 0.0
max_y = 1.0
min_y = 0.0


def deep_learning_turbidite(resdir,
                            X_train_raw,
                            y_train_raw,
                            X_test_raw,
                            y_test_raw,
                            lr=0.02,
                            decay=0,
                            validation_split=0.2,
                            batch_size=32,
                            momentum=0.9,
                            nesterov=True,
                            num_layers=4,
                            dropout=0.5,
                            node_num=2000,
                            epochs=4000):
    """
    Creating the inversion model of turbidity currents by deep learning
    """
    #Normalizing dataset
    X_train = get_normalized_data(X_train_raw, min_x, max_x)
    X_test = get_normalized_data(X_test_raw, min_x, max_x)
    y_train = get_normalized_data(y_train_raw, min_y, max_y)
    y_test = get_normalized_data(y_test_raw, min_y, max_y)

    # Generate the model
    # mirrored_strategy = MirroredStrategy()
    # with mirrored_strategy.scope():
    model = Sequential()
    model.add(
        Dense(node_num,
              input_dim=X_train.shape[1],
              activation='relu',
              kernel_initializer='glorot_uniform'))  #1st layer
    model.add(Dropout(dropout))
    for i in range(num_layers - 2):
        model.add(
            Dense(node_num,
                  activation='relu',
                  kernel_initializer='glorot_uniform'))  #2nd layer
        model.add(Dropout(dropout))
    model.add(
        Dense(y_train.shape[1],
              activation='relu',
              kernel_initializer='glorot_uniform'))  #last layer

    # Compilation of the model
    model.compile(
        loss="mean_squared_error",
        optimizer=SGD(lr=lr, decay=decay, momentum=momentum,
                      nesterov=nesterov),
        #optimizer=Adadelta(),
        metrics=["mean_squared_error"])

    # Start training
    t = time.time()
    check = ModelCheckpoint(filepath=os.path.join(resdir, "model.hdf5"),
                            monitor='val_loss',
                            save_freq=1000,
                            save_weights_only=True,
                            mode='min',
                            save_best_only=True)
    #es_cb = EarlyStopping(monitor='val_loss', patience=5, verbose=0, mode='auto')
    tb_cb = TensorBoard(log_dir=os.path.join(resdir, 'logs'),
                        histogram_freq=0,
                        write_graph=False,
                        write_images=False)
    history = model.fit(X_train,
                        y_train,
                        epochs=epochs,
                        validation_split=validation_split,
                        batch_size=batch_size,
                        callbacks=[check, tb_cb])

    return model, history


def apply_model(model, X, min_x, max_x, min_y, max_y):
    """
    Apply the model to data sets
    """
    X_norm = (X - min_x) / (max_x - min_x)
    Y_norm = model.predict(X_norm)
    Y = Y_norm * (max_y - min_y) + min_y
    return Y


def plot_history(history):
    # plot training history
    plt.plot(history.history['mean_squared_error'], "o-", label="mse")
    plt.plot(history.history['val_mean_squared_error'], "o-", label="val mse")
    plt.title('model mse')
    plt.xlabel('epoch')
    plt.ylabel('mse')
    plt.legend(loc="upper right")
    plt.show()


def test_model(model, x_test):
    #test the model

    x_test_norm = get_normalized_data(x_test, min_x, max_x)
    test_result_norm = model.predict(x_test_norm)
    test_result = get_raw_data(test_result_norm, min_y, max_y)

    return test_result


def save_result(savedir, model=None, history=None, test_result=None):

    if test_result is not None:
        np.savetxt(os.path.join(savedir, 'test_result.txt'),
                   test_result,
                   delimiter=',')
    if history is not None:
        np.savetxt(os.path.join(savedir, 'loss.txt'),
                   history.history.get('loss'),
                   delimiter=',')
        np.savetxt(os.path.join(savedir, 'val_loss.txt'),
                   history.history.get('val_loss'),
                   delimiter=',')

     if model is not None:
        print('save the model')
        model.save(savedir + 'model.hdf5')


def load_data(datadir):
    """
    This function load training and test data sets, and returns variables
    """
    global min_x, max_x, min_y, max_y

    x_train = np.load(os.path.join(datadir, 'H_train.npy'))
    x_test = np.load(os.path.join(datadir, 'H_test.npy'))
    y_train = np.load(os.path.join(datadir, 'icond_train.npy'))
    y_test = np.load(os.path.join(datadir, 'icond_test.npy'))
    min_y = np.load(os.path.join(datadir, 'icond_min.npy'))
    max_y = np.load(os.path.join(datadir, 'icond_max.npy'))
    [min_x, max_x] = np.load(os.path.join(datadir, 'x_minmax.npy'))

    return x_train, y_train, x_test, y_test


def set_minmax_data(_min_x, _max_x, _min_y, _max_y):
    global min_x, max_x, min_y, max_y

    min_x, max_x, min_y, max_y = _min_x, _max_x, _min_y, _max_y
    return


def get_normalized_data(x, min_val, max_val):
    """
    Normalizing the training and test dataset
    """
    x_norm = (x - min_val) / (max_val - min_val)

    return x_norm


def get_raw_data(x_norm, min_val, max_val):
    """
    Get raw data from the normalized dataset
    """
    x = x_norm * (max_val - min_val) + min_val

    return x


if __name__ == "__main__":

    # Load data
    datadir_training_num = './distance/10/data'
    resdir_training_num = './result_training_num_10'
    if not os.path.exists(resdir_training_num):
        os.mkdir(resdir_training_num)

    x_train, y_train, x_test, y_test = load_data(datadir_training_num)

    # Start training
    # testcases_train_num = [500, 1000, 1500, 2000, 2500, 3000, 3500]
    testcases_train_num = []
    for i in range(len(testcases_train_num)):
        resdir_case = os.path.join(resdir_training_num,
                                   '{}/'.format(testcases_train_num[i]))
        if not os.path.exists(resdir_case):
            os.mkdir(resdir_case)
        x_train_sub = x_train[0:testcases_train_num[i], :]
        y_train_sub = y_train[0:testcases_train_num[i], :]
        model, history = deep_learning_turbidite(resdir_case,
                                                 x_train_sub,
                                                 y_train_sub,
                                                 x_test,
                                                 y_test,
                                                 epochs=20000,
                                                 num_layers=6)
        # Verification and test
        # model = load_model(os.path.join(resdir_case, 'model.hdf5'))
        result = test_model(model, x_test)
        save_result(resdir_case,
                    model=model,
                    history=history,
                    test_result=result)
        # save_result(resdir_case, test_result=result)

    # #load data 
    # datadir_distance = './distance'
    # resdir_distance = './result_distance_3500_2'

    # #学習の実行
    # num_data = 3500
    # # testcases_distance = [1, 2, 3, 4, 5, 10]
    # testcases_distance = [15, 20, 25, 30]
    # for i in range(len(testcases_distance)):
    #     x_train, y_train, x_test, y_test = load_data(
    #         os.path.join(datadir_distance, '{}'.format(testcases_distance[i]),
    #                      'data'))
    #     resdir_case = os.path.join(resdir_distance,
    #                                '{}/'.format(testcases_distance[i]))
    #     if not os.path.exists(resdir_case):
    #         os.mkdir(resdir_case)
    #     x_train_sub = x_train[0:num_data, :]
    #     y_train_sub = y_train[0:num_data, :]
    #     model, history = deep_learning_turbidite(resdir_case,
    #                                              x_train_sub,
    #                                              y_train_sub,
    #                                              x_test,
    #                                              y_test,
    #                                              epochs=20000,
    #                                              num_layers=6)

    #     
    #     # model = load_model(os.path.join(resdir_case, 'model.hdf5'))
    #     result = test_model(model, x_test)
    #     save_result(resdir_case, model=model, history=history, test_result=result)
    #     # save_result(resdir_case, test_result=result)
