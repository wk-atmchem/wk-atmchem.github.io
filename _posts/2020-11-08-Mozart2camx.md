---
layout:     post
title:      mozart2camx compile and install
subtitle:   空气质量模型 
date:       2020-11-08
author:     吴锴
header-img: img/cmaq-tdep.png
catalog: true
tags:
    - 科研
    - 博客
    - 漫谈
---

# Introduction of ICON and BCON in regional air quality modeling
The initial and boundary conditions (hereafter referred as ICON and BCON, respectively) are essential components in air quality modeling especially for regional air quality models such as CMAQ, CAMx and WRF-Chem. In general, there are two choices can be adopted for generating initial and boundary conditions, as described below:
(I)  use clean atmosphere (In CMAQ model, the choice (I) is the default option which means the profile option in ICON and BCON scripts.) 
(II) use global model's output 


For specific air pollution episodes especially for significant contributions from regional transport (or long range transport), accurate boundary conditions are of great importantance in reproducing the epsides. Therefore, the option (II) is always the best choice for regional air quality modeling work. 

In this post, we will introduce how to use the mozart2camx tool to generate ICON and BCON for CMAQ model.

## I.Install the pre-requested libs 

The pre-requested libs for mozart2camx installation are IOAPI, netcdf-c, netcdf-fortran. Please refer to another post for learning how to install these libs.

## II.Install mozart2camx

Download the mozart2camx-26feb19.tgz file from the website http://www.camx.com/download/support-software.aspx .

1.`tar -zxvf mozart2camx-26feb19_1.tgz` 

Then you will get the package of mozart2camx in the current path，as shown in the Figure below:
![1mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/1mozart.png)

2.`cd mozart2camx_v3.2.1/` enter the path and use the command of `ls` to look at the framework of this program, as shown below:
![2mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/2mozart.jpg)

3.`cd src` 

enter the src path

4.`cp Makefile.mzrt2camx Makefile`

Because we will use the `make` command to generate the execute file, here we copy the Makefile.mzrt2camx to Makefile.

5.`vi Makefile`
Enter the Makefile and revise it accordingly based on your compiler and settings of netcdf, ioapi libs.
For example, in my HPC system, the revised Makefile is shown below:
![3mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/3mozart.png)
After the revision finished, use the command of `:wq` for keeping the changes made in Makefile.

6.`make S07TC_AE6__GEOS5`
This command is used to make the execute file.
It should be noted that several mechnisms are available for this make command, as shown below. Since my work mainly use the SAPRC07 mechnism, here we choose S07TC_AE6__GEOS5 option.
![4mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/4mozart.jpg)
![5mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/5mozart.png)

7.Then we need to compile another execute file which is utilized to convert netcdf format mozart file to IOAPI format file.
`cd ../ncf2ioapi_mozart`

`cp Makefile.NCF2IOAPI Makefile`

`vi Makefile`
Then revise the Makefile accordingly (which is almost same as the Makefile in Step 5)

`make`
Then the execute file will be produced.
![6mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/6mozart.png)

如果对于本文的编译过程有什么意见或者建议，欢迎您发邮件跟我交流(邮箱：wukaicuit@gmail.com)。

