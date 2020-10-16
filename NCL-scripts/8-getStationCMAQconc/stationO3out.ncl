;Written by Kai Wu, UC Irvine, September, 2020
; contact wukaicuit@gmail.com
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

  months	= (/"01","06"/) ;月份通过循环mm控制
  types        = (/"BASE/","nobio/","onlybio/"/)   ;类型case通过循环tt控制
  vars          = (/"O3","SOA"/);变量通过循环xx控制

  dir   = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/output_CCTM_2016-06-BASEnest_sichuan1010/"

;地理信息
  fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/mcip/2016-06-BASE-sichuan/GRIDCRO2D_2016150.nc"
  fmap    = addfile(fmapname,"r")

lat = 30.69
lon = 104.18


do mm = 1, 1
do tt = 0, 0  ;;;不用调
do vv = 0, 0  ;;;不调节 只画O3
  var   = vars(vv)
  units		= (/"ug/m~S1~3","micrograms/m~S1~3"/)
  righttitle    = units(vv)+"    "+vars(vv)
; lefttitle     = var(vv)
;fab表示a和b;fa表示a;fb表示b路径
;计算数据 xab，xa，xb
	ff = systemfunc("ls " + dir +  "CCTM_ACONC_2016-" + months(mm) + "-BASE_201606*")
   print(ff)
    day1 = dimsizes(ff)
    data = new((/day1,24,1,182,232/),"float")
     

    do dd = 0, day1 - 1
			f = addfile(ff(dd), "r")
			data(dd,:,:,:,:) = f->$var$(:,:,:,:)* 1000 * 48 / 22.4
		end do
;;;站点模拟O3
;;;提取经纬度信息  
   LON = fmap->LON
   LAT = fmap->LAT
printVarSummary(LON)
printVarSummary(LAT)

;  filename1 = "wrfout_d01_2017-07-26_00:00:00.nc"
;  a1 = addfile("/GFPS8p/xyyang/wk/CMAQ-5.2.1/PREP/mcip/WRF_LINK/2017-07-BASE/" + filename1,"r")
;  it = 0
;   XLAT = wrf_user_getvar(a1,"XLAT",it)   ; latitude/longitude
;  XLONG = wrf_user_getvar(a1,"XLONG",it)  ; required for plotting
;  XLAT_I = XLAT(6:187,6:237)
;   XLONG_I  = XLONG(6:187,6:237)

;  opt = True
;  loc = getind_latlon2d(LAT(0,0,:,:), LON(0,0,:,:), lat, lon)
;  print(loc)
;  print(LON(0,0,77,95))
;  print(LAT(0,0,77,95))
  data_loc = rcm2points(LAT(0,0,:,:),LON(0,0,:,:),data(:,:,:,:,:),lat,lon,0)
printVarSummary(data_loc)

;  monitor_mis = data_loc(:,:,0,loc(0),loc(1))
  asciiwrite("new.txt",data_loc)
  
  end do
  end do
  end do
  print("---------------- Done!!! -------------------")
end
