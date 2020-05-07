#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
os.environ['PROJ_LIB'] = 'D:\anaconda3\pkgs\proj-7.0.0-haa36216_3\Library\share\proj'
from mpl_toolkits.basemap import Basemap
import glob
from satpy.scene import Scene
import proplot as plot
import cmaps
from cartopy.io.shapereader import Reader
import cartopy.feature as cfeature
from cartopy import crs as ccrs

f_s5p_pattern = 'D:/CMAQ/TROPOMI/tropomi_no2_20200301/S5P_OFFL_L2__NO2____20200301T053638_20200301T071808_12341_01_010302_20200304T104828.nc'
f_s5p = glob.glob(f_s5p_pattern)
scn = Scene(f_s5p, reader='tropomi_l2')# print(scn.available_dataset_names())
vnames = ['nitrogendioxide_tropospheric_column',
          'assembled_lat_bounds', 'assembled_lon_bounds',
          ]
scn.load(vnames)
lon_bounds = scn['assembled_lon_bounds']
lat_bounds = scn['assembled_lat_bounds']# copy attrs
attrs = scn['nitrogendioxide_tropospheric_column'].attrs
# The multiplication factor to convert mol/m2 to molec/cm2 is
#   6.02214*1e19.
scn['VCD'] = 6.02214*1e5*scn['nitrogendioxide_tropospheric_column']
scn['VCD'].attrs = attrs
scn['VCD'].attrs['units'] = r'10$^{16}$ molec. /cm$^2$'# create colormap
tropomi_no2_cmap = plot.Colormap('YlGnBu_r', 'YlOrRd',
                                 ratios=(1, 4), name='tropomi_no2',
                                 )# set axis
f, axs = plot.subplots(proj='pcarree')
# For plot the whole China map
# axs.format(labels=True,
#            lonlines=10,
#            latlines=10,
#            lonlim=(75, 135),
#            latlim=(15, 55),
#            geogridcolor='w'
#            )

# For plot the Sichuan Basin
axs.format(labels=True,
           lonlines=1,
           latlines=1,
           lonlim=(102,108),
           latlim=(28, 32),
           geogridcolor='w'
           )


# plot the map
def add_shape(source, projection):
    return cfeature.ShapelyFeature(Reader(source).geometries(),
                                   projection, facecolor='none')

def load_province(projection=ccrs.PlateCarree()):
        source = 'D:\matlabshp\cn_province.shp'
        return add_shape(source,projection)

provinces = load_province()
axs.add_feature(provinces, edgecolor='k', linewidth=.3)

m = axs.pcolormesh(lon_bounds, lat_bounds,
                   scn['VCD'],
                   cmap=cmaps.WhiteBlueGreenYellowRed,
                   levels=256,
                   vmin=0,
                   vmax=100,
                   )# set colorbar and title

axs.format(collabels=['TROPOMI NO$_2$ VCD'],
           title='',
           titlesize=6,
           )
cb = axs.colorbar(m, loc='r',
                  label=scn['VCD'].attrs['units'],
                  values=plot.arange(0, 100, 10),
                  )# save

f.savefig('D:/CMAQ/TROPOMI/tropomi_no2_20200301/tropomi_example.png')
