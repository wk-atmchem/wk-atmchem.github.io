;Written by Kai Wu @UC Davis ATM 
;Email: atmwu@ucdavis.edu
;All rights reserved.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

  dir   = "/GFPS8p/xyyang/zgl/thesis/CMAQ/"

;地理信息
  fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/mcip/2020-04-BASE-sichuan/GRIDCRO2D_2020131.nc"
  fmap    = addfile(fmapname,"r")

	lat = 30.65639     ;站点的经纬度
	lon = 104.0239     ;站点的经纬度   

	ff = systemfunc("ls " + dir +  "CCTM_ACONC_*")
    print(ff)
    day1 = dimsizes(ff)
    data = new((/day1,24,1,182,232/),"float")
     

    do dd = 0, day1 - 1
			f = addfile(ff(dd), "r")
			data(dd,:,:,:,:) = f->O3(:,:,:,:)* 1000 * 48 / 22.4
	  end do
;;;站点模拟O3
;;;提取经纬度信息  
   LON = fmap->LON
   LAT = fmap->LAT

  data_loc = rcm2points(LAT(0,0,:,:),LON(0,0,:,:),data(:,:,:,:,:),lat,lon,0)

  asciiwrite("new.txt",data_loc)

  print("---------------- Done!!! -------------------")
end
