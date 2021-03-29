# -*- coding: utf-8 -*-
"""
Created on Sun Mar 28 16:09:14 2021

@author: wukai
"""


import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

viridis = cm.get_cmap('Spectral_r', 200)
print(viridis)

#print('viridis.colors', viridis.colors)
print('viridis(range(200))', viridis(range(200)))
print('viridis(np.linspace(0, 1, 200))', viridis(np.linspace(0, 1, 200)))