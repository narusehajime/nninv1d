nninv1d
========================

This is a code for inverse analysis of sedimentary processes by using a deep learning neural network. 

---------------
Installation

python setup.py install

---------------
How to use 

import nninv1d
import os

# Load data
datadir_training_num = './distance/10/data'
resdir_training_num = './result_training_num_10'
if not os.path.exists(resdir_training_num):
    os.mkdir(resdir_training_num)

x_train, y_train, x_test, y_test = nninv1d.load_data(datadir_training_num)

# Start training
testcases_train_num = [500, 1000, 1500, 2000, 2500, 3000, 3500]
for i in range(len(testcases_train_num)):
    resdir_case = os.path.join(resdir_training_num,
                               '{}/'.format(testcases_train_num[i]))
    if not os.path.exists(resdir_case):
        os.mkdir(resdir_case)
    x_train_sub = x_train[0:testcases_train_num[i], :]
    y_train_sub = y_train[0:testcases_train_num[i], :]
    model, history = nninv1d.deep_learning_turbidite(resdir_case,
                                             x_train_sub,
                                             y_train_sub,
                                             x_test,
                                             y_test,
                                             epochs=20000,
                                             num_layers=6)
# Verification and test
model = nninv1d.load_model(os.path.join(resdir_case, 'model.hdf5'))
result = nninv1d.test_model(model, x_test)
save_result(resdir_case, model=model, history=history, test_result=result)


