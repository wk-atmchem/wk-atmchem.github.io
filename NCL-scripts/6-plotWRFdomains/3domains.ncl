; This script is used to plot the three nested domains used in WRF simulation.
; Written by Kai Wu, UC Irvine, September, 2020
; contact wukaicuit@gmail.com
;

begin

ndomains = 3
files = new((ndomains),"string")
files(0) = "/GFPS8p/xyyang/wk/WRF4.1.1/WPS-4.1/geo_em.d01.nc"
files(1) = "/GFPS8p/xyyang/wk/WRF4.1.1/WPS-4.1/geo_em.d02.nc"
files(2) = "/GFPS8p/xyyang/wk/WRF4.1.1/WPS-4.1/geo_em.d03.nc"
;files(2) = "/GFPS8p/xyyang/wk/WRF3.9.1/WPS_3.9.1/geo_em.d01.nc"

f0 = addfile(files(0),"r")
hgt   = wrf_user_getvar(f0,"HGT",0)
landmask0 = f0->LANDMASK(0,:,:)
xlat0 = f0->XLAT_M(0,:,:)
xlon0 = f0->XLONG_M(0,:,:)
hgt   = where(landmask0.eq.0,hgt@_FillValue,hgt) ;将海洋mask掉
hdim     = dimsizes(xlat0)
;print(hdim)
nlat     = hdim(0)
nlon     = hdim(1)
max_lat0  = xlat0(nlat-1,nlon-1)
max_lon0  = xlon0(nlat-1,nlon-1)
min_lat0  = xlat0(0,nlon-1)
min_lon0  = xlon0(nlat-1,0)

hgt@lat2d = xlat0
hgt@lon2d = xlon0
wks = gsn_open_wks("pdf","newdomainplot")       ; Where to send the graphics
;cmap = read_colormap_file("OceanLakeLandSnow")
cmap = read_colormap_file("MPL_terrain")

;--- Set some plotting resources for contours
res = True
res@cnFillOn          = True                   ; Turn on color fill
res@cnFillPalette     = cmap(:,:)
res@cnFillMode        = "MeshFill"
res@gsnAddCyclic      = False
res@cnLinesOn         = False
res@cnLineLabelsOn    = False
res@gsnDraw           = False
res@gsnFrame          = False
res@cnInfoLabelOn     = False
res@lbLabelBarOn      = True
res@mpGridAndLimbOn       = True      ; Turn off lat/lon lines
res@pmTickMarkDisplayMode = "Always"  ; Turn on map tickmarks
res@mpProjection        = "LambertConformal"


;!!!!!Note:the following three lines need to be revised accordingly.!!!!
res@mpLambertParallel1F = 15  ; namelist -> truelat1 
res@mpLambertParallel2F = 40  ; namelist -> truelat2
;res@mpLambertMeridianF  = 107.438
res@mpLambertMeridianF  = 114 ; namelist -> ref_lon


res@mpDataBaseVersion = "MediumRes"
res@mpAreaMaskingOn   = True
res@mpMaskAreaSpecifiers = "land"
res@gsnLeftString     = ""
res@mpNationalLineThicknessF    = 3.0
res@mpGeophysicalLineThicknessF = 4.0
res@gsnRightString    = ""
res@mpLimitMode        = "Corners"
; res@mpLeftCornerLatF   = min(xlat0)
; res@mpLeftCornerLonF   = min(xlon0)
; res@mpRightCornerLatF  = max(xlat0)
; res@mpRightCornerLonF  = max(xlon0)
res@mpLeftCornerLatF   = xlat0(0,0)
res@mpLeftCornerLonF   = xlon0(0,0)
res@mpRightCornerLatF  = max_lat0
res@mpRightCornerLonF  = max_lon0
res@cnLevelSelectionMode =  "ManualLevels"
res@cnMinLevelValF       =  0.
res@cnMaxLevelValF       =  6000.
res@cnLevelSpacingF      =  150.
res@mpFillOn             = True
res@mpOceanFillColor     = "LightBlue"
res@mpLandFillColor      = "transparent"
res@mpDataBaseVersion           = "MediumRes"
res@mpDataSetName               = "Earth..4"
res@mpOutlineBoundarySets       = "National"
res@mpOutlineSpecifiers         = (/"China","China:Provinces"/)
res@lbTitleOn            = True
res@lbTitleFontHeightF   = 0.02
res@lbTitleString        = "Terrain Height (m)"


Lres = True
Lres@gsLineColor      = "black"
Lres@gsLineThicknessF = 3.5
yy = new((2*nlat+2*nlon+1),float)
yy(0:nlon-1) = (/xlat0(0,0:nlon-1)/)
yy(nlon:nlat-1+nlon-1) = (/xlat0(1:nlat-1,nlon-1) /)
yy(nlat+nlon:2*nlon+nlat-1) = (/xlat0(nlat-1,nlon-1:0:-1) /)
yy(2*nlon+nlat:2*nlon+2*nlat-1) = (/xlat0(nlat-1:0:-1,0) /)

xx = new((2*nlat+2*nlon+1),float)
xx(0:nlon-1) = (/xlon0(0,0:nlon-1)/)
xx(nlon:nlat-1+nlon) = (/xlon0(0:nlat-1,nlon-1) /)
xx(nlat+nlon:2*nlon+nlat-1) = (/xlon0(nlat-1,nlon-1:0:-1) /)
xx(2*nlon+nlat:2*nlon+2*nlat-1) = (/xlon0(nlat-1:0:-1,0) /)

txres               = True
txres@txFontColor   = "red"
txres@txFontHeightF =  0.02
txx   = (max_lon0+min_lon0)/2
txy   = max_lat0-(max_lat0-min_lat0)*0.05

hgt_map      = gsn_csm_contour_map(wks,hgt,res)
domain00     = gsn_add_polyline(wks,hgt_map,xx(0:nlon-1),yy(0:nlon-1),Lres)
domain01     = gsn_add_polyline(wks,hgt_map,xx(nlon:nlat-1+nlon),yy(nlon:nlat-1+nlon),Lres)
domain02     = gsn_add_polyline(wks,hgt_map,xx(nlat+nlon:2*nlon+nlat-1),yy(nlat+nlon:2*nlon+nlat-1),Lres)
domain03     = gsn_add_polyline(wks,hgt_map,xx(2*nlon+nlat:2*nlon+2*nlat-1),yy(2*nlon+nlat:2*nlon+2*nlat-1),Lres)
text0       = gsn_add_text(wks,hgt_map,"d01",txx,txy,txres)

; domain 02
  f02 = addfile(files(1),"r")
  hgt02   = wrf_user_getvar(f02,"HGT",0)
  landmask02 = f02->LANDMASK(0,:,:)
  hgt02   = where(landmask02.eq.0,hgt02@_FillValue,hgt02)
  xlat02 = f02->XLAT_M(0,:,:)
  xlon02 = f02->XLONG_M(0,:,:)
  hdim02     = dimsizes(xlat02)
  nlat02     = hdim02(0)
  nlon02     = hdim02(1)
  hgt02@lat2d = xlat02
  hgt02@lon2d = xlon02
  ;hgt02 = where(hgt02.lt.seaside,hgt02@_FillValue,hgt02)
  max_lat02 = xlat02(nlat02-1,0);max(xlat02)
  max_lon02 = xlon02(nlat02-1,0);max(xlon02)
  min_lat02 = xlat02(0,nlon02-1);min(xlat02)
  min_lon02 = xlon02(0,nlon02-1);min(xlon02)

  yy := new((2*nlat02+2*nlon02+1),float)
  yy(0:nlon02-1) = (/xlat02(0,0:nlon02-1)/)
  yy(nlon02:nlat02-1+nlon02-1) = (/xlat02(1:nlat02-1,nlon02-1) /)
  yy(nlat02+nlon02:2*nlon02+nlat02-1) = (/xlat02(nlat02-1,nlon02-1:0:-1) /)
  yy(2*nlon02+nlat02:2*nlon02+2*nlat02-1) = (/xlat02(nlat02-1:0:-1,0) /)

  xx := new((2*nlat02+2*nlon02+1),float)
  xx(0:nlon02-1) = (/xlon02(0,0:nlon02-1)/)
  xx(nlon02:nlat02-1+nlon02) = (/xlon02(0:nlat02-1,nlon02-1) /)
  xx(nlat02+nlon02:2*nlon02+nlat02-1) = (/xlon02(nlat02-1,nlon02-1:0:-1) /)
  xx(2*nlon02+nlat02:2*nlon02+2*nlat02-1) = (/xlon02(nlat02-1:0:-1,0) /)

  txx   = (max_lon02+min_lon02)/2
  txy   = max_lat02;-(max_lat02-min_lat02)*0.08
  res@gsnMaximize  = False  ; Use maximization from original plot
  res@lbLabelBarOn = False
  res@gsnLeftString     = ""
  res@gsnRightString    = ""
  res@gsnCenterString   = ""
  hgt_map02     = gsn_csm_contour(wks,hgt02,res)
  domain20     = gsn_add_polyline(wks,hgt_map,xx(0:nlon02-1),yy(0:nlon02-1),Lres)
  domain21     = gsn_add_polyline(wks,hgt_map,xx(nlon02:nlat02-1+nlon02),yy(nlon02:nlat02-1+nlon02),Lres)
  domain22     = gsn_add_polyline(wks,hgt_map,xx(nlat02+nlon02:2*nlon02+nlat02-1),yy(nlat02+nlon02:2*nlon02+nlat02-1),Lres)
  domain23     = gsn_add_polyline(wks,hgt_map,xx(2*nlon02+nlat02:2*nlon02+2*nlat02-1),yy(2*nlon02+nlat02:2*nlon02+2*nlat02-1),Lres)
  text02    = gsn_add_text(wks,hgt_map,"d02",txx,txy,txres)

; domain 03

f03 = addfile(files(2),"r")
hgt03  = wrf_user_getvar(f03,"HGT",0)
landmask03 = f03->LANDMASK(0,:,:)
hgt03   = where(landmask03.eq.0,hgt03@_FillValue,hgt03)
xlat03 = f03->XLAT_M(0,:,:)
xlon03 = f03->XLONG_M(0,:,:)
hdim03     = dimsizes(xlat03)
nlat03     = hdim03(0)
nlon03     = hdim03(1)
hgt03@lat2d = xlat03
hgt03@lon2d = xlon03
;hgt03 = where(hgt03.lt.seaside,hgt03@_FillValue,hgt03)
max_lat03 = xlat03(nlat03-1,0);max(xlat03)
max_lon03 = xlon03(nlat03-1,0);max(xlon03)
min_lat03 = xlat03(0,nlon03-1);min(xlat03)
min_lon03 = xlon03(0,nlon03-1);min(xlon03)

yy := new((2*nlat03+2*nlon03+1),float)
yy(0:nlon03-1) = (/xlat03(0,0:nlon03-1)/)
yy(nlon03:nlat03-1+nlon03-1) = (/xlat03(1:nlat03-1,nlon03-1) /)
yy(nlat03+nlon03:2*nlon03+nlat03-1) = (/xlat03(nlat03-1,nlon03-1:0:-1) /)
yy(2*nlon03+nlat03:2*nlon03+2*nlat03-1) = (/xlat03(nlat03-1:0:-1,0) /)

xx := new((2*nlat03+2*nlon03+1),float)
xx(0:nlon03-1) = (/xlon03(0,0:nlon03-1)/)
xx(nlon03:nlat03-1+nlon03) = (/xlon03(0:nlat03-1,nlon03-1) /)
xx(nlat03+nlon03:2*nlon03+nlat03-1) = (/xlon03(nlat03-1,nlon03-1:0:-1) /)
xx(2*nlon03+nlat03:2*nlon03+2*nlat03-1) = (/xlon03(nlat03-1:0:-1,0) /)

txx   = (max_lon03+min_lon03)/2
txy   = max_lat03;-(max_lat03-min_lat03)*0.1
hgt_map03     = gsn_csm_contour(wks,hgt03,res)
domain30     = gsn_add_polyline(wks,hgt_map,xx(0:nlon03-1),yy(0:nlon03-1),Lres)
domain31     = gsn_add_polyline(wks,hgt_map,xx(nlon03:nlat03-1+nlon03),yy(nlon03:nlat03-1+nlon03),Lres)
domain32     = gsn_add_polyline(wks,hgt_map,xx(nlat03+nlon03:2*nlon03+nlat03-1),yy(nlat03+nlon03:2*nlon03+nlat03-1),Lres)
domain33     = gsn_add_polyline(wks,hgt_map,xx(2*nlon03+nlat03:2*nlon03+2*nlat03-1),yy(2*nlon03+nlat03:2*nlon03+2*nlat03-1),Lres)
text03   = gsn_add_text(wks,hgt_map,"d03",txx,txy,txres)


;overlay(hgt_map,hgt_map02)
;overlay(hgt_map,hgt_map03)
draw(hgt_map)
frame(wks)
end
