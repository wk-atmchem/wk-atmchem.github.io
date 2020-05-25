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