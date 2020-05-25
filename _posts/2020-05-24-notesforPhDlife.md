---
layout:     post
title:      读博日记
subtitle:   daily notes for research progress
date:       2020-05-24
author:     吴锴
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - satellite
    - models
---

# 2020.5.24
1.发现NCEP产品中有North American Regional Reanalysis (NARR) dataset，可考虑后续利用该数据作为驱动WRF的初始场和边界场
2.地表温度数据可以使用 California Irrigation Management Information System (CIMIS)的气温数据
3.在分析WRF-UCM-Chem的时候，城市气温应该使用模式底层的温度而不是2米地温，因为WRF-Chem模块计算的时候用的是grid cell的温度
4.CO is always considered a conservative tracer.
5.夜间大气冷却。在城市地区，因建筑材料的使用白天热量有所储蓄，夜间释放热量导致大气cooling作用有所削弱。此外，城市地区因热量释放导致夜间边界层升高，也对大气夜间cooling作用有削弱(因为cooling作用分布到了更深的边界层中)。
During nighttime atmosphere cools. The energy stored in the building during daytime (what authors call upward ground heat flux, I suppose) reduces the cooling. The higher PBL in the urban simulation will reduce the cooling too because the effect of the surface cooling is distributed in a greater depth than in the no-urban case. The two mechanisms (energy stored in buildings, and high PBL), both reduce cooling. They do not compete they go in the same direction.
6.美国气象数据可通过以下方式下载：
Observations are obtained from MesoWest (https://mesowest.utah.edu/), which are available at Mesonet API (https://developers.synopticdata.com/mesonet/).
