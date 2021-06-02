---
layout:     post
title:      更新WRF里的SST
subtitle:   WRFsst update
date:       2021-3-19
author:     Kai Wu
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - satellite
    - models
---

# 2020.05.24
资料下载
SST   ftp://polar.ncep.noaa.gov/pub/history/sst
FNL

WRF  前处理
运行 geogrid
           与一般情况相同
运行 ungrib
            分别对FNL 资料与SST 资料进行解压。
首先 使用 link_grib.csh 链接 fnl 资料
       ./link_grib.csh fnl*

链接合适的 Vtable
       ln -sf  ungrib/Variable_Tables/Vtable.GFS   Vtable

在namelist.wps 中 &share 部分作如下改动
       &share
       start_date = '2006-09-23_00:00:00',
       end_date = '2006-09-24_00:00:00',
       interval_seconds = 21600,

执行 ungrid.exe
       ./ungrib.exe
       产生
      FILE:2006-09-23_00
      FILE:2006-09-23_06
      FILE:2006-09-23_12
      FILE:2006-09-23_18
      FILE:2006-09-24_00

然后，使用 link_grib.csh 链接SST 数据
       ./link_grib.csh rtg_sst*
链接合适的 Vtable（选择 Vtable.SST）
       ln -sf  ungrib/Variable_Tables/Vtable.SST   Vtable

编辑 namelist.wps 中的 &share 和 &ungrib 部分
             注意：SST数据的间隔时间以天为计。所以需要将SST插值至6小时间隔，以匹配FNL资料。通过将 interval_seconds=21600，可以将SST数据插值至6小时。通过要注意改变prefix，这样才不会覆盖掉之前解压的fnl。
      &share
      start_date = '2003-07-02_00:00:00',
      end_date = '2003-07-03_00:00:00',
      interval_seconds = 21600,
      &ungrib
      prefix = 'SST',

执行 ungrib.exe
      ./ungrib.exe
      产生
      SST:2006-09-23_00
      SST:2006-09-23_06
      SST:2006-09-23_12
      SST:2006-09-23_18
      SST:2006-09-24_00

运行 metgrid

更改namelist.wps 中的 &metgrid 部分
     &metgrid
     fg_name = 'FILE', 'SST'

执行 metgrid
     ./metgrid.exe
      产生
     met_em.d01.2006-09-23_00:00:00.nc
     met_em.d01.2006-09-23_06:00:00.nc
     met_em.d01.2006-09-23_12:00:00.nc
     met_em.d01.2006-09-23_18:00:00.nc
     met_em.d01.2006-09-24_00:00:00.nc

运行 WRF 主模块
      编辑 namelist.input，在&time_control 和&physics 部分添加
     &time_control
     auxinput4_inname = "wrflowinp_d<domain>"
     auxinput4_interval = 360,
     io_form_auxinput4 = 2,
     &physics
     sst_update = 1,

       这些参数将在模式模拟中每6小时更新一次sst。
       不要更改auxinput4_inname。

运行 real
链接 metgrid 输出文件
        ln -sf ../../../WPS/met_em* .
执行 real.exe
       运行成功，产生下列文件，（wrflowinp_d01包含SST信息）
   wrfbdy_d01
   wrfinput_d01
   wrflowinp_d01

运行 WRF
与一般情况一样，执行 wrf.exe