---
layout:     post
title:      WRF常见bug及解决方案
subtitle:   WRF常见bug及解决方案
date:       2021-6-3
author:     Kai Wu
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - models
---

# Summary of WRF bugs and solutions 

### [WPS Errors: Ungrib.exe Segmentation Fault]
When running Ungrib.exe crashes at the ungribbing process at the end date, giving error message: "Segmentation fault ..."  
Causes:  
Probably, it has something with computer memory, because when I set ulimit to unlimited, the problem was solved.
Solution:  
ulimit -s unlimited  

### [WPS Errors: Metgrid.exe error in ext_pkg_write_field]
Symptoms:
Metgrid.exe crashes at the beginning of the process with messages: 'ERROR: Error in ext_pkg_write_field'.  
Causes:  
This will happen when new NCEP GFS data (Version 15.1 or higher) was process using old version of ungrib.exe (< Ver. 4).  
Solution:  
Install Ungrib from WPS Ver.4. (the old geogrid/metgrid still could be used).  

### [WRF Errors: WARNING: Field XXX has missing values]

When running metgrid.exe, I encountered the following error:

      'WARNING: Field PRES has missing values at level 200100 at (i,j)=(1,1)'
      'WARNING: Field PRES has missing values at level 200100 at (i,j)=(1,1)'
      'WARNING: Field PRESSURE has missing values at level 200100 at (i,j)=(1,1)'
      'WARNING: Field PMSL has missing values at level 200100 at (i,j)=(1,1)'
      'WARNING: Field PSFC has missing values at level 200100 at (i,j)=(1,1)'
      'WARNING: Field SOILHGT has missing values at level 200100 at (i,j)=(1,1)'
      'ERROR: Missing values encountered in interpolated fields. Stopping.'

The solution was so easy. In short, please check that your ungribbed data domain includes the domain which you are trying to extract with metgrid.  
The error occurs when the intermediate files prepared by ungrib.exe (and, potentially, calc_ecmwf_p.exe) do not cover the full domain as defined in namelist.wps.  
This can happen, e.g., if the meteorological fields are not global. In my case, I had downloaded ECMWF data for central Europe only, and then later extended the model domain a bit. Once I re-downloaded the meteorological data, everything went smoothly.  
解决方案：下载的再分析资料小于模型模拟设置的domain，下载更大范围的再分析资料即可.  

### [WRF Errors: could not find trapping x locations]
When running real.exe, I encountered the following error:

      'troubles, could not find trapping x locations'

Apparently, the x in the error message could not find trapping x locations is referring to general x values in the interpolation subroutine lagrange_setup (so x is not related to longitude!). Looking for sfcprs3 in the source code file, one can find
      'Computes the surface pressure by vertically interpolating'
      'linearly (or log) in z the pressure, to the targeted topography.'  
The solution was to download all 137 model levels by using LEVELIST=1/to/137 in the MARS request. When doing that, the lnsp is indeed contained in the model level Grib files.  
解决方案：这个报错是由于缺失垂直层数据导致的，下载ERA5再分析资料的所有垂直层的资料即可.  

### [WRF Errors: Mismatch Landmask ivgtyp]
When running real.exe, there might be an error named:

       '-------------- FATAL CALLED ---------------'
       'FATAL CALLED FROM FILE: LINE: 2963'
       'mismatch_landmask_ivgtyp'
       '-------------------------------------------'

The Solutions:  
Change the value of 'surface_input_source' on &physics parameter of namelist.input from '3' to '1'  
在namelist的&physics部分加上一句surface_input_source = 1, 即可解决  

### [WRF Errors: WRF Simulation Sudden Death]
Symptoms:  
Model crashed. Real.exe and Wrf.exe are abruptly stopped, without any error messages in log files. It just stop.  
Causes:  
I hate this error because it might caused by many factors, but mostly because of the conflicts within the model configuration. For example, I was using WSM-3 MP parameterization schemes, with RRTM schemes for LW and SW, with domain over high latitude and complex terrain, 10 km resolution, using several computation nodes, then many strange things happened: the model crashed many times, could only stable while running on single node, etc.  
On several cases, it's also caused by too large time-step similar with CFL error.  
Sometimes, it also occurs if the domain is too large, in particular when grid size < 10 km with complex terrain.  
Solutions:  
1.Change the model configuration. For my case, I used Lin MP scheme with new RRTM schemes, and the error was gone.  
2.Reduce the time-step in the factor of 2 (half of time-step first, if still not works, try 0.25 of the original time-step, and so on).  
3.Reduce the domain size.  

### [WRF Errors: WRF Simulation Sudden Death]
Symptoms: 
WRF generates messages such as : "x points exceeded cfl=x in domain d0x at time ..."  
Simulation speed degrades or simulation completely stops.  
Causes:  
Model becomes unstable, mostly because the time-step used is too large for stable solution, especially while using high-res simulation grids.  
Conflicts among model physics/dynamics/domains configuration.  
Solutions:  
Decrease the time-step (namelist.input > &domain > time_step).  The most common used convention is 6*DX in kilometers. That means, if the grid resolution is 10 km, then use at least 60 seconds time step. If the messages still appear, decrease the time step to 30 or 10 seconds.  
Check the parameterization/configuration used in namelist.input which could potentially cause conflicts or model crash. I usually discard some parameterization schemes, and check them individually to see if I they are the causes of the crash.  