; This script is used to plot the one domain used in WRF simulation.
; Written by Kai Wu, UC Irvine, September, 2020
; contact wukaicuit@gmail.com
; Note: This script is only applied for plot one domain.

begin

ndomains = 1
files = new((ndomains),"string")
files(0) = "/GFPS8p/xyyang/wk/WRF4.1.1/WPS-4.1/geo_em.d03.nc"

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
wks = gsn_open_wks("pdf","1")       ; Where to send the graphics
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
res@mpLambertParallel1F = 34.0  ; namelist -> truelat1
res@mpLambertParallel2F = 34.0  ; namelist -> truelat2
;res@mpLambertMeridianF  = 107.438
res@mpLambertMeridianF  = 110.0 ; namelist -> ref_lon

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
res@cnMaxLevelValF       =  7000.
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
;res@lbTitleString        = "Terrain Height (m)"


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
;text0       = gsn_add_text(wks,hgt_map,"d01",txx,txy,txres)

draw(hgt_map)
frame(wks)
end
