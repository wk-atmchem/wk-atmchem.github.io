load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin 
 
  dir = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/PREP/mcip/WRF_LINK/2020-04-BASE-sichuan/"
  fils = systemfunc("ls "+dir+"wrfout_d01_2020*")   
  f   = addfiles(fils,"r")
  ter = wrf_user_getvar(f, "rh2", -1)  ;SURFACE SKIN TEMPERATURE
  ter = ter
  printVarSummary(ter)
  times = wrf_user_getvar(f,"times",-1)
  xlat=wrf_user_getvar(f,"XLAT",0)
  xlon=wrf_user_getvar(f,"XLONG",0)
  printVarSummary(xlat)
  printVarSummary(xlon)


  lat=30.7489
  lon=103.8611
  
  data_loc = rcm2points(xlat(:,:),xlon(:,:),ter(:,:,:),lat,lon,1)
  asciiwrite("rh2.txt",data_loc) 

end
