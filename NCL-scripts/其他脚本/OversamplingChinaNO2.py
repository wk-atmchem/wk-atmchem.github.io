# -*- coding: utf-8 -*-
"""
Created on Thu Oct  8 14:47:17 2020

@author: wukai
"""

import sys
import os
os.environ['PROJ_LIB'] = 'D:\anaconda3\pkgs\proj-7.0.0-haa36216_3\Library\share\proj'
import logging
import cmaps
from calendar import monthrange
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon


start_year = 2020
start_month = 3
end_year = 2020
end_month = 3
l2_dir = 'E:/4research/TROPOMIchina/'
l2g_dir = 'E:/4research/TROPOMIchina/'
popy_dir = 'C:/Users/wukai/OneDrive/桌面/TROPOMI卫星数据处理/popy/'

sys.path.insert(0,popy_dir)
from popy import popy

logging.basicConfig(level=logging.DEBUG)

if not os.path.exists(l2_dir):
    os.makedirs(l2_dir)
if not os.path.exists(l2g_dir):
    os.makedirs(l2g_dir)


for year in range(start_year,end_year+1):
    for month in range(1,13):
        if year == start_year and month < start_month:
            continue
        elif year == end_year and month > end_month:
            continue
        # call popy to subset data
        s5p = popy(instrum="TROPOMI",product="NO2",grid_size=0.02,\
                west=75,east=132,south=15,north=50,\
                start_year=year,start_month=month,start_day=1,\
                end_year=year,end_month=month,end_day=31,\
        #        end_year=year,end_month=month,end_day=monthrange(year,month)[-1],\
                end_hour=23,end_minute=59,end_second=59)
        # subset
        s5p.F_subset_S5PNO2(l2_dir)
        l2g_path = l2g_dir+'CONUS_'+"{:0>4d}".format(year)+'_'+"{:0>2d}".format(month)+'.mat'
        # save subset to a .mat file
        s5p.F_save_l2g_to_mat(l2g_path,\
                      data_fields=['column_amount','column_uncertainty','cloud_fraction','SolarZenithAngle',
                      'UTC_matlab_datenum','across_track_position'],\
                      data_fields_l2g=['colno2','colno2error','cloudfrac','sza','utc','ift'])
        # if .mat file l2g_path is already saved
        # s5p.F_mat_reader(l2g_path)
        # regrid level 2 to level 3
        s5p.F_regrid_ccm()
        # plot level 3 data on a map
        #m = Basemap(projection='cyl')
        # m = Basemap(projection='lcc',llcrnrlat=30,urcrnrlat=45,\
        #             llcrnrlon=110,urcrnrlon=130,resolution='c',lat_1=25.,lat_2=40,lat_0=34,lon_0=110.)
        m = Basemap(projection='cyl',llcrnrlat=15,urcrnrlat=55,\
            llcrnrlon=72,urcrnrlon=136,resolution='c')
        plt.rcParams["font.family"] = "Arial"
        
        
        # labels = [left,right,top,bottom]
        parallels = np.arange(20., 55., 7.)    # 这两行画纬度，范围为[-90,90]间隔为10
        m.drawparallels(parallels,labels=[True, False, False, False],fontsize=14)
        meridians = np.arange(85., 125., 10.)   # 这两行画经度，范围为[-180,180]间隔为10
        m.drawmeridians(meridians,labels=[False, False, False, True],fontsize=14)
        
        m.readshapefile("D:/matlabshp/cnshapefile/china",  'china', drawbounds=True)
        #m.drawstates(linewidth=0.5)
        #m.drawcoastlines(linewidth=0.5)
        cmap=cmaps.WhiteBlueGreenYellowRed
        # convert units
        C = s5p.C['column_amount']*6.02214*1e4
        C[s5p.quality_flag!=0] = np.nan
        p = m.pcolormesh(s5p.xgrid,s5p.ygrid,C,cmap=cmap,vmin=0,vmax=12)
        #m.colorbar(p,label=r'NO$_2$ tropospheric column [10$^15$ mol/cm$^2$]')
        cb=plt.colorbar(p)
        cb.ax.tick_params(labelsize=14)
        
        font = {'family' : 'Arial','size'   : 14,}
        cb.set_label(r'NO$_2$ tropospheric column [10$^{15}$mol/cm$^2$]',fontdict=font)
        plt.tight_layout()
        plt.savefig("filename.png",dpi=1200)
        # plt.clim([0,3e-4])