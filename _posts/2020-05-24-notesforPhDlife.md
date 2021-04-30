---
layout:     post
title:      读博日记
subtitle:   daily notes for research progress
date:       2021-1-4
author:     Kai Wu
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - satellite
    - models
---

# 2020.05.24
1.发现NCEP产品中有North American Regional Reanalysis (NARR) dataset，可考虑后续利用该数据作为驱动WRF的初始场和边界场

2.地表温度数据可以使用 California Irrigation Management Information System (CIMIS)的气温数据

3.在分析WRF-UCM-Chem的时候，城市气温应该使用模式底层的温度而不是2米地温，因为WRF-Chem模块计算的时候用的是grid cell的温度

4.CO is always considered a conservative tracer.

5.夜间大气冷却。在城市地区，因建筑材料的使用白天热量有所储蓄，夜间释放热量导致大气cooling作用有所削弱。此外，城市地区因热量释放导致夜间边界层升高，也对大气夜间cooling作用有削弱(因为cooling作用分布到了更深的边界层中)。
During nighttime atmosphere cools. The energy stored in the building during daytime (what authors call upward ground heat flux, I suppose) reduces the cooling. The higher PBL in the urban simulation will reduce the cooling too because the effect of the surface cooling is distributed in a greater depth than in the no-urban case. The two mechanisms (energy stored in buildings, and high PBL), both reduce cooling. They do not compete they go in the same direction.

6.美国气象数据可通过以下方式下载：
Observations are obtained from MesoWest (https://mesowest.utah.edu/), which are available at Mesonet API (https://developers.synopticdata.com/mesonet/).

7.A good introduction flow is as follows:
The flow of the introduction section is as follows. First, we point out that urbanization has led to profound modification of the land surface. We then explain how changes in land surface properties can affect regional meteorological fields such as surface and air temperature, wind speed and PBL height. We go on to demonstrate how those changes in meteorology due to land surface modification can in turn affect air pollutant concentrations via different mechanisms. While there are a number of studies that have investigated the impacts of land surface changes on regional meteorology,limited studies have quantified the impact of land surface changes on regional air quality, especially for the Southern California region, which has a history of severe air pollutant problems. In addition, recent studies have made it possible to utilize satellite land surface data in model simulations, which better predict regional weather in urbanized regions, and urban versus nonurban differences. Thus, our study adopts the modified model configuration, and aims to characterize the influence of historical urbanization on urban meteorology and air quality in Southern California.

# 2020.05.25
1.工厂的污染物的排放可以通过EPA的网站下载
Air pollutant emissions from large U.S. power plants are tracked hourly by EPA’s continuous emission monitoring systems (CEMS) database (https://ampd.epa.gov/ampd/). 

2.评估自上而下的NOx排放量的不确定性，通过bootstrapping方法来进行评估
In order to quantify the uncertainty associated with the topdown NOX estimates, we use a bootstrapping technique to evaluate the sensitivity of the estimates to the selection of days.In this method, we randomly replace entire daily TROPOMI scenes with scenes from other days. We perform
this random replacement 100 times to generate a distribution of estimates around the mean top-down NOX estimates.
NOX bottom-up emissions data can be found here: https://www.epa.gov/airemissions-inventories/air-pollutant-emissions-trends-data. 
Annual CEMS data from power plants can be downloaded here: https://ampd.epa.gov/ampd/. 

# 2020.11.09
1.CMAQv5.3中存在一个BCON时间步长的问题——要求输入数据为逐小时的时间步长，因此Mozart2camx得到的6小时一次的边界场无法被CMAQv5.3读取.
From Christian Hogrefe (US EPA), any CMAQ version other than CMAQv5.3 does not require BC files to have hourly time steps. CMAQv5.3 did have that limitation but it was addressed in CMAQv5.3.1.

# 2020.12.23
1.Python利用xlrd读取excel文件报错：raise XLRDError(FILE_FORMAT_DESCRIPTIONS[file_format]+'; not supported'). 
这是因为xlrd的高版本跟pandas里的支持不对应导致的，通过以下命令降低版本即可： 
pip install xlrd==1.2.0 boto3

# 2021.1.4
1.当FNL数据因为垂直层更新而导致无法完成连续模拟的时候，可采取如下解决办法： 
利用WPS/util目录下的mod_levs.exe程序可以将ungrib出的中间文件移除某些垂直层次使之一致。具体做法是在namelist.wps中添加： 

&mod_levs 
press_pa = 201300 , 200100 , 100000 , 
             95000 ,  90000 , 
             85000 ,  80000 , 
             75000 ,  70000 , 
             65000 ,  60000 , 
             55000 ,  50000 , 
             45000 ,  40000 , 
             35000 ,  30000 , 
             25000 ,  20000 , 
             15000 ,  10000 , 
              5000 ,   1000 
/ 

press_pa就是你想保留的垂直层次（其余的层次会被移除） 
然后链接mod_levs.exe到wps目录下，运行： 
./mod_levs.exe FILE:2016-05-11_18 new_FILE:2016-05-11_18 
再修改&metgrid中fg_name='new_FILE'即可。 


# 2021.1.20
1.Linux下find命令的使用 
模板：find path -name filename 
find /GFPS8p/xyyang/wk -name wrfout_d02_2012-04-30_00:00:00  

# 2021.3.29
1.利用CDO裁剪nc文件里的区域  
cdo sellonlatbox,60,160,0,60 IASI_NH3_9yr_AM.nc china.nc  

# 2021.1.20
1.关于CMAQ中的SOA yield的解释： 
SOA yields vary as a function of time of day because the chemical pathways leading to SOA vary during the day. See the schematic from the v5.3 release notes for a summary of pathways in CMAQ: CMAQ/aero7_overview.md at master · USEPA/CMAQ · GitHub. All those pathways are active at all times of day to varying degrees. You can find the manuscripts documenting SOA development here: https://www.epa.gov/cmaq/how-cite-cmaq#Particle_Microphysics_and_Chemistry. Many of the development papers include plots of typical diurnal variation for each system. 

