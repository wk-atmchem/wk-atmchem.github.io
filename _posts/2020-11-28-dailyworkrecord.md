---
layout:     post
title:      ESTA tool notes
subtitle:   Emissions Spatial and Temporal Allocator
date:       2021-01-18
author:     Kai Wu
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - Emission Inventory
    - models
---

# 2021.01.18
Emissions Spatial and Temporal Allocator (ESTA)由加州空气资源管理局开发，是一个基于python的排放清单处理工具。
尽管其设计目的为处理所有排放清单，但目前其仅支持onroad-emission的处理。

目前支持EMFAC2017 emission的读取和处理，并可选择是否输出柴油机的PM排放.
NH3_data_EF17目录中包含了几年的NH3排放文件，用户可以将NH3排放文件的具体年份追加到EMFAC2017排放文件中。
将NH3排放文件追加到EMFAC2017排放文件的脚本提供在EF17_format_ld和EF17_format_hd目录下。当前版本的NH3清单是MPO009。

ESTA是基于Python2.7的代码。

用于测试的样例数据给定的是：
EMFAC2017当中的Light-Duty vehicles和Heavy-Duty vehicles

ARB uses both diurnal and day-of-week temporal profiles from the California Vehicle Activity Database (CalVAD). 


All of the provided example config files are set up for the same Wednesday in the summer of 2017:

执行python preprocess_grid_boxes.py -gridcro2d GRIDCRO2D.California_4km_270x297 -rows 270 -cols 297  -regions california_counties_lat_lon_bounding_boxes.csv
生成的county信息会打印到屏幕上，然后将其粘贴到空白的py文件中，并保存
/dfs5/apep/wuk15/ESTA/input/defaults/domains/county_boxes_ca_4km.py