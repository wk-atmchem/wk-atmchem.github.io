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

在Linux的terminal中按顺序输入如下命令：

1.`tar -xzvf netcdf-c-4.7.0.tar.gz`

这一步即为解压netcdf-c的这个tar包，解压完成后会在当前路径下出现一个netcdf-c-4.7.0的文件夹
如下图所示：
![netcdf-ctar](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdf-ctar.png)

2.`cd netcdf-c-4.7.0` 进入netcdf-c-4.7.0文件夹

然后输入`ls`发现文件夹内部结构如下
![netcdf-c2](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdf-c2.png)

3.`mkdir ../netcdf-c-4.7.0-intel` 

这步即为在解压出来的netcdf-c目录的上一层目录创建一个名为netcdf-c-4.7.0-intel的文件夹

4.`cd ../netcdf-c-4.7.0-intel`
进入步骤3创建的名为netcdf-c-4.7.0-intel的文件夹

5.`pwd`
通过pwd命令得知当前文件夹的路径
以本文为例(如下图所示)，路径为/home/kai/lib/new/netcdf-c-4.7.0-intel
![netcdfcpwd](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdfcpwd.png)

6.`./configure --prefix=/home/kai/lib/new/netcdf-c-4.7.0-intel --disable-netcdf-4 --disable-dap` 
然后我们回到解压出来的netcdf-c目录下执行编译(注意：是解压得到的netcdf-c文件夹  而不是我们自己通过mkdir创建的文件夹)

7.`make check install` 

对安装结果进行测试  是否成功编译   如编译成功   则会出现如下提示：
Congratulations! You have successfully installed netCDF!
![netcdf-c3](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdf-c3.png)

8.`cd /home/kai/lib/new/netcdf-c-4.7.0-intel`
进入目标文件夹   利用`ls`命令查看   出现下图所示4个文件夹  即为安装成功
![netcdfcfinal](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdfcfinal.png)

## II.Install mozart2camx

Download the mozart2camx-26feb19.tgz file from the website http://www.camx.com/download/support-software.aspx .

1.`tar -zxvf mozart2camx-26feb19_1.tgz` 

Then you will get the package of mozart2camx in the current path，as shown in the Figure below:
![1mozart](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/1mozart.png)

2.`cd netcdf-fortran-4.4.5` 进入netcdf-fortran-4.4.5文件夹  然后`ls`查看当前文件夹下的文件 发现内部结构如下
![netcdf-ff2](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/netcdff2.png)

3.`mkdir ../netcdf-f-4.4.5-intel` 

这步即为在解压出来的netcdf-f目录的上一层目录创建一个名为netcdf-f-4.4.5-intel的文件夹

4.`cd ../netcdf-f-4.4.5-intel`
进入步骤3创建的名为netcdf-f-4.4.5-intel的文件夹

5.`pwd`
通过pwd命令得知当前文件夹的路径
以本文为例，路径为/home/kai/lib/new/netcdf-f-4.4.5-intel

6.`vi ~/.bashrc`
为了保证编译顺利  进入bashrc文件 并把netcdf-c的路径加入到LD_LIBRARY当中 
`export LD_LIBRARY_PATH=/home/kai/lib/new/netcdf-c-4.7.0-intel/lib:$LD_LIBRARY_PATH` 
然后保存修改 
`:wq` 
注意：如果本步骤未执行，则可能会导致下一步出现"cannot compute sizeof"的报错

7.然后我们回到解压出来的netcdf-f文件夹下执行编译(注意：是解压得到的netcdf-f文件夹  而不是我们自己通过mkdir创建的文件夹)

利用以下命令执行编译

`./configure --prefix=/home/kai/lib/new/netcdf-f-4.4.5-intel LDFLAGS="-L/home/kai/lib/new/netcdf-c-4.7.0-intel/lib" CPPFLAGS="-I/home/kai/lib/new/netcdf-c-4.7.0-intel/include" CC=icc FC=ifort` 

注意点：在编译netcdf-f的时候，我们需要调用编译好的netcdf-c的2个库的位置LDFLAGS和CPPFLAGS来分别代表地址。因此，我们需要先编译netcdf-c，再编译netcdf-f。


8.`make check`
执行make check后  经过一系列Testuite Summary之后出现下图即为成功
![makecheck](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/makecheck.png)

9.`make install`
执行make install后  出现下图即为成功安装
![makeinstall](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/makeinstall.png)


## III.编译易错点总结

1.在编译netcdf-c和netcdf-f时，需要分清楚自己创建的文件夹和通过解压tar包得到的文件夹。编译都是在解压tar包所得到的文件夹中进行，然后通过编译命令将编译出的netcdf-c和netcdf-f指定到我们创建的文件夹下。

2.编译顺序，如上所述，由于netcdf-f的编译依赖于netcdf-c的2个库的位置。因此我们需要先编译netcdf-c，再编译netcdf-f。

## IV.IOAPI3.2编译

IOAPI3.2的编译较netcdf-c和netcdf-f的编译稍显复杂，因此，在编译IOAPI时，需要保持清醒。

1.在目录下新建ioapi-3.2的文件夹
`mkdir ioapi-3.2`

然后将ioapi-3.2.tar.gz移动到新建的ioapi-3.2的文件夹中

2.执行`tar -zxvf netcdf-fortran-4.4.5.tar.gz`将tar包解压到当前目录下

解压完成后会在当前路径下出现若干个文件夹和文件，如下图所示：
![ioapi1](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/ioapi1.png)

3.完成步骤2后，执行`cp Makefile.template Makefile`将解压出来的`Makefile.template`复制为`Makefile`

4.执行`vi Makefile`对Makefile进行以下修改

第133行的BIN修改为
`BIN        = Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`

第141行的NCFLIBS修改为
`NCFLIBS    = -lnetcdff -lnetcdf`

保存修改后退出

5.执行`cd ioapi`进入解压得到的ioapi文件夹

6.执行以下命令将Makeinclude.Linux2_x86_64ifort复制为Makeinclude.Linux2_x86_64ifort_openmpi_3.1.4_intel18.2

`cp Makeinclude.Linux2_x86_64ifort Makeinclude.Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`

7.执行`vi Makeinclude.Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`进入复制得到的Makeinclude文件

因为我们使用的是2018年的Intel编译器，因此进行如下修改：将第27和28行的openmp都改为qopenmp，如下所示

OMPFLAGS  = -qopenmp

OMPLIBS   = -qopenmp

修改完成后退出

8.执行`cd ..`回到原始目录下   然后执行`mkdir Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`创建目标文件夹(IOAPI会编译到这个文件夹中)

9.执行`cd Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`进入刚刚创建的文件夹

然后通过以下2条命令将编译IOAPI所需的netcdf-c和netcdf-f的2个文件链接到当前目录

`ln -s /home/kai/lib/new/netcdf-c-4.7.0-intel/lib/libnetcdf.a`

`ln -s /home/kai/lib/new/netcdf-f-4.4.5-intel/lib/libnetcdff.a`

然后执行`ls`命令查看2个.a文件是否已成功链接到当前目录下。如下图所示，即为成功。
![ioapilink](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/ioapilink.png)

10.执行`cd ..`回到原始目录下   然后执行`make all`命令 进行IOAPI的编译
等待几分钟后，编译完成且无报错，如下图所示。
![ioapi11](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/ioapi11.png)

11.执行`cd Linux2_x86_64ifort_openmpi_3.1.4_intel18.2`进入Linux2_x86_64ifort_openmpi_3.1.4_intel18.2文件夹中并分别利用以下2条命令查看是否编译成功

`ls -lrt libioapi.a`

`ls -rlt m3xtract`

若如下图所示即为成功
![ioapifinal](https://raw.githubusercontent.com/wk-atmchem/wk-atmchem.github.io/master/img/ioapifinal.png)

至此，编译CMAQv5.3.1所需要的netCDF-C, netCDF-Fortran, IOAPI都已安装完毕。

# 写在最后
本文主要介绍了基于Intel编译库对CMAQv5.3.1的几个库进行了编译。因笔者自接触CMAQ以来一直使用的都是Intel编译器，因此基于GNU的编译方法，读者可以参考US EPA的教程，网址为：
https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_build_library_gcc.md

下一篇推文我们将介绍CMAQ安装完成后的运行过程。

如果对于本文的编译过程有什么意见或者建议，欢迎您发邮件跟我交流(邮箱：wukaicuit@gmail.com)。

