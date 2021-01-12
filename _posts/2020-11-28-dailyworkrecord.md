---
layout:     post
title:      博士期间每日工作纪要
subtitle:   daily notes for work record
date:       2020-11-28
author:     Kai Wu
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - satellite
    - models
---

# 2020.11.28
1.完成了2012年6月加州的MEGANv2.1的计算，有待画图分析和对比  
2.阅读了UCLA的空气污染与气候变化协同治理报告Coordinated-Governance-Chinese-8-2020-v2的前2个章节，refresh了对加州空气质量管控的认识  
3.完成了太湖上针对北美区域的MEGANv2.1的Prep的install，路径为：
/GFPS8p/xyyang/wk/meganwk/MEGANv2.10/prepmegan4cmaq_2014-06-02

# 2020.11.29
1.调试完成了利用ISAM计算MEIC当中5类排放源分别对臭氧的影响  
(/GFPS8p/xyyang/wk/CMAQ-5.3.2/CCTM/scripts/run_cctm_SCB_ISAM_MEICtag.csh)  
注意多个面源文件的EMIS_LABEL不可以简单写为AGR,TRA,IND等  
2.从华电曹靖原处获取了正确的ISAM的四川盆地的mask文件  

# 2020.11.30
1.华电曹靖原给的ISAM的mask文件有问题——报错显示Fortran string too short,后来写了NCL脚本通过将该文件的变量值替换到原来我制作的有偏移的文件中，成功制作了正确的mask文件，为后续溯源工作的开展奠定了基础  
2.ArcGIS当中如果需要修改属性表，需注意如下步骤：  
首先，要添加列，可直接左上角添加，注意双精度，10位数  
其次，要修改属性表的值，需要在GIS正上方找到编辑器，开启编辑器模式，进入属性表方可进行修改，否则属性表无法修改  

# 2020.12.18
1.完成四川盆地2020年持续臭氧污染机制的文章并准备投稿到STE——完成 

# 2020.12.19
1.寻找南加州空气盆地的空气质量观测网的演变的相关数据——从EPA AQS network以及其他渠道寻找信息 
2.去看UCR的Ivey老师的文章，继续了解SoCAB的臭氧污染的研究现状 
3.到HPC3上开始全年的CMAQ模拟 注意需要自行进行MCIP处理以及日期转换 

# 2020.12.23
1.干货 | 关于“增长”的14种表达https://zhuanlan.zhihu.com/p/24489432 

# 2021.1.12
1.阅读"2005–2017 ozone trends and potential benefits of local measures as deduced from air quality measurements in the north of the Barcelona metropolitan area"，考虑如何深挖环境监测数据并改进EP文章当中观测部分内容的分析
2.在HPC3上安装mozart2camx的更新版，处理CAM-Chem的测试，并反馈给Mike和朱博
3.构思refinery文章的框架和思路  发给Mike
4.完成EP文章的模式模拟