# -*- coding: utf-8 -*-
"""
Created on Sun May  3 17:14:54 2020
Revised version of plotting CMAQ output from Stacy's script'
@author: Kai Wu
Email:atmwu@ucdavis.edu

"""

# Libraries
#--------------
from matplotlib import pyplot as plt ; from matplotlib import colors
import numpy as np; import numpy.ma as ma; from matplotlib.patches import Path, PathPatch
import pandas as pd; from shapely.geometry import Point, shape, Polygon;import fiona
from shapely.ops import unary_union, cascaded_union; from geopandas.tools import sjoin
import geopandas as gpd; import geoplot; import glob; import os; from datetime import timedelta, date;
from netCDF4 import Dataset
import scipy.ndimage; from cartopy import crs as ccrs; import cartopy.io.shapereader as shpreader
import matplotlib.path as mpath; import seaborn as sns; import cartopy.feature as cfeature
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
import proplot as plot; import cmaps
from cartopy.io.shapereader import Reader
#------------------------------------------

# dir to grid file
dir='D:/Pythonstudy/grid/27kmchina/' 
ll='GRIDCRO2D_2016362.nc' 

# dir to model files
dir_files= 'D:/CMAQ/2017yearCMAQresults/'

#pull files from given directoy
onlyfiles = next(os.walk(dir_files))[2]
onlyfiles=sorted(onlyfiles) # so that searching for dates are easier

# pull only CONC files
fnames = [x for x in onlyfiles if x.startswith("COMBINE_ACONC_2017-07-BASE")]
numfiles=(len(fnames))

# check the number of CONC files
print("the number of COMBINE_ACONC file is",numfiles)

#get lat lon from grid file
ll=Dataset(dir+ll,'r')
lat,lon=ll['LAT'][:],ll['LON'][:]

# check the longitude and latitude
#print(lat,lon)

#pull in files and variables
ncfile= [Dataset(dir_files+fnames[i],'r') for i in range(len(fnames))]


#full day conc
no2 = [np.average(ncfile[i]['NO2'][:],axis=0) for i in range(len(fnames))]
no2_hourly=np.average(no2,axis=0)
#hourly conc
#daytime_hours = [12,13,14,15,16,17,18,19,20,21,22,23,1]
daytime_hours = [11,12,13,14,15,16]
no2_daytime = [ncfile[i]['NO2'][daytime_hours[j]] for j in range(len(daytime_hours)) for i in range(len(fnames))]
no2_daytime_avg = np.average(no2_daytime,axis=0)

O3 = [np.average(ncfile[i]['O3'][:],axis=0) for i in range(len(fnames))]
O3_hourly = np.average(O3,axis=0)
#O3_hourly = [ncfile[i]['O3'][18] for i in range(len(fnames))]
O3_daytime = [ncfile[i]['O3'][daytime_hours[j]] for j in range(len(daytime_hours)) for i in range(len(fnames))]
O3_daytime_avg = np.average(O3_daytime,axis=0)

CO = [np.average(ncfile[i]['CO'][:],axis=0) for i in range(len(fnames))]
CO=np.average(CO,axis=0)


# set var for plot
var='O3'
data=pd.DataFrame(O3_daytime_avg[0])*48/22.4
#print(data)

#==================================================
#Set up for projections
#select any projection listed below and uncomment it
crs_new = ccrs.PlateCarree(central_longitude=110.0, globe=None)
#crs_new = ccrs.AlbersEqualArea(central_longitude=110.0, central_latitude=34, 
#                               false_easting=0.0, false_northing=0.0, 
#                               standard_parallels=(25.0, 40.0), globe=None)

#crs_new = ccrs.LambertConformal(central_longitude=110.0, central_latitude=34.0, 
#                                false_easting=0.0, false_northing=0.0, 
#                                secant_latitudes=None, standard_parallels=(25.0, 40.0), 
#                                globe=None, cutoff=-30)


# create your own colormap 
#ir_br = plot.Colormap('spectral', name='ir_br',
#                       save=True,
#                      )

# set axis
f, axs = plot.subplots(proj='pcarree')
#f, axs = plot.subplots(projection=crs)

# make fig object
axs.format(labels=True,
           lonlines=10,
           latlines=10,
           lonlim=(75, 135),
           latlim=(15, 55),
           geogridlinewidth=0.5)

#If want to use the minimum and maximum of lon and lat, uncomment the following two lines
#           lonlim=(lon.min(), lon.max()),
#           latlim=(lat.min(), lat.max()),

# read the shapefile
#china = shpreader.Reader('D:\matlabshp\cn_province.shp')
#js = shpreader.Reader('D:\matlabshp\cn_province.shp')


# axs.add_feature(cfeature.ShapelyFeature(china.geometries(), 
#                                       crs_new, 
#                                       facecolor='none', 
#                                       edgecolor='k',
#                                       linewidth=1.5))


# plot the map
def add_shape(source, projection):
    return cfeature.ShapelyFeature(Reader(source).geometries(),
                                   projection, facecolor='none')

def load_province(projection=ccrs.PlateCarree()):
        source = 'D:\matlabshp\cn_province.shp'
        return add_shape(source,projection)

provinces = load_province()
axs.add_feature(provinces, edgecolor='k', linewidth=.3)

# set levels
cb_levels = plot.arange(0, 180, 20)

# plot data
# if want to change the colormap, revise the cmap line accordingly
m = axs.contourf(lon[0,0,...],lat[0,0,...], data,
                   cmap=cmaps.WhiteBlueGreenYellowRed,
#                   cmap=ir_br,
                   vmin=0, vmax=180,
                   levels=100)

# set others
axs.format(title='')

# set colorbar to the rightside
#axs.colorbar(m, loc='r', values=cb_levels, label='O3 concentration')

# set colorbar to the bottom
axs.colorbar(m, loc='b', values=cb_levels, label='O3 concentration')
# f.savefig('./figures/proplot_pcarree_levels.jpg')
f.savefig(var+'daytime.png', dpi=600, bbox_inches='tight')














