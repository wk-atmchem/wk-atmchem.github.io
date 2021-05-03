load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

	fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/mcip/2020-04-BASE-sichuan/GRIDCRO2D_2020120.nc"
	fmap    = addfile(fmapname,"r")

	lat = 30.72358    ;站点的纬度
	lon = 103.9728    ;站点的经度   

    dSizes = getfiledimsizes(f)

    dir = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/POST/"
	fab = systemfunc("ls " + dir + "COMBINE_ACONC_2019SCB*")
    print(fab(0))  
    day1 = dimsizes(fab)
    
    tot = 0

    do dd = 0, day1 - 1
        ffab = addfile(fab(dd), "r")
        ftime = ffab->TFLAG(:,:,:,:)
        dTime = getfiledimsizes(ftime)
        dNames = getfiledimnames(f)
        print(dTime+"   "+dNames)
        tot = tot + dTime
    end do

    data_ab = new((/day1,tot,1,182,232/),"float")
    
    do dd = 0, day1 - 1
        ffab = addfile(fab(dd), "r")
        
        data_ab(dd,:,:,:,:) = ffab->O3(:,:,:,:) * 48 / 22.4

    end do

   LON = fmap->LON
   LAT = fmap->LAT

  data_loc = rcm2points(LAT(0,0,:,:),LON(0,0,:,:),data_ab(:,:,:,:,:),lat,lon,1)
  asciiwrite("jqlh.txt",data_loc)
  
  print("---------------- Done!!! -------------------")
end
