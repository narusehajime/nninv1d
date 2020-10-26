# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

with open('README.rst') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='nninv1d',
    version='0.1.0',
    description=
    'Inverse model of sedimentary processes from their deposits by using a deep learning neural network',
    long_description=readme,
    author='Hajime Naruse',
    author_email='naruse@kueps.kyoto-u.ac.jp',
    url='https://github.com/narusehajime/nninv1d',
    license=license,
    install_requires=[
        'numpy',
        'matplotlib',
        'tensorflow',
    ],
    packages=find_packages(exclude=('tests', 'docs')))
