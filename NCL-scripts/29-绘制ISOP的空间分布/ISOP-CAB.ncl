load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

  var = "isoprene"
  dir = "/GFPS8p/xyyang/wk/MEGANv2.10/Output/"
;地理信息
  fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/mcip/2016-07-CA/GRIDCRO2D_2016051.nc"
  fmap    = addfile(fmapname,"r")

	fab = systemfunc("ls " + dir + "MEGANv2.10.M_04_08CA.tons.20160*")
    print(fab(0))  
    day1 = dimsizes(fab)
    data_ab = new((/day1,25,1,291,321/),"float")
      
    do dd = 0, day1 - 1
		ffab = addfile(fab(dd), "r")
		printVarSummary(ffab->$var$)
		print(dd)
		data_ab(dd,:,:,:,:) = ffab->$var$(:,:,:,:)
	end do

	xab = dim_avg_n(dim_avg_n(data_ab, (/1,2/)), 0)*24*365

printVarSummary(xab)
;计算

        tmpab     = ndtooned(xab)
        abmean   = dim_avg(tmpab)
      

;;;;画图
   fon   = 111
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500
   wks     = gsn_open_wks(wks_type,fon)
;    wks     = gsn_open_wks("png","ab-a-b-SOA")
;        clbdft  = "WhiteBlueGreenYellowRed"                      ; Colorbar Default
        clbdft  = "MPL_jet"
;        clbdft  = "sunshine_9lev"
  setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues

;The following domain works for SoCAB		
;		lon1 = 204   ;;;修改画图左下角和右上角格点数  1左下  2右上   0-231
;		lon2 = 236  ;;;  lon1-231
;		lat1 = 50   ;;;  0-181
;		lat2 = 83  ;;;  lat1-181
		

               lon1 = 184   ;;;修改画图左下角和右上角格点数  1左下  2右上   0-231
               lon2 = 255  ;;;  lon1-231
               lat1 = 40   ;;;  0-181
               lat2 = 93  ;;;  lat1-181
        gsn_define_colormap(wks,clbdft)

        res                     = True	; plot mods desired
        res@gsnDraw             = False	; turn off draw
        res@gsnFrame            = False          ; don't advance frame yet
        res@gsnSpreadColors     = True	; use full range of colormap
        res@cnFillOn            = True	; color plot desired
        res@cnLinesOn           = False ; turn off contour lines
        res@cnLineLabelsOn      = False ; turn off contour labels
        res@cnFillMode       = "RasterFill"
        res@tfDoNDCOverlay              = True

        res@mpOutlineOn           = True
	res@mpGeophysicalLineThicknessF = 10
        res@mpCountyLineThicknessF= 10
 	res@mpOutlineSpecifiers   = "conterminous us : counties"
	res@mpFillAreaSpecifiers  = "conterminous us : counties"
	res@mpOutlineBoundarySets = "AllBoundaries"      ; "geophysical"
	res@mpFillBoundarySets    = "geophysical"
	res@mpDataBaseVersion     = "MediumRes" 
	res@mpDataSetName         = "Earth..4"
        res@tmXTOn                      = False
        res@tmYROn                      = False

	res@mpProjection        = "LambertConformal"
	res@mpLambertParallel1F = 30.
	res@mpLambertParallel2F = 60.
	res@mpLambertMeridianF  = -120.5

	res@mpLimitMode         = "Corners"
	res@mpLeftCornerLatF    = fmap->LAT(0,0,lat1,lon1)
	res@mpLeftCornerLonF    = fmap->LON(0,0,lat1,lon1)
	res@mpRightCornerLatF   = fmap->LAT(0,0,lat2,lon2)
	res@mpRightCornerLonF   = fmap->LON(0,0,lat2,lon2)

;if using longitudes/latitudes ranges to specify the plot domain, uncomment following lines
;res@mpLimitMode         = "LatLon"
;res@mpMinLatF           = 32.     ; map area
;res@mpMaxLatF           = 36.         ; latitudes
;res@mpMinLonF           = -122.      ; and
;res@mpMaxLonF           = -116.        ; longitudes

;******Contour mode****************
res@pmTickMarkDisplayMode       = "Always"  ; use NCL default lat/lon labels
res@lbOrientation       = "Vertical"        ; vertical label bar
res@pmLabelBarOrthogonalPosF = 0.1          ; move label bar closer
res@gsnMaximize        = True               ; maximize the plot
res@cnLevelSelectionMode= "ManualLevels"    ; set manual contour levels
res@cnMinLevelValF      =  0                ; set min contour level
res@cnMaxLevelValF      =  3000              ; set max contour level
res@cnLevelSpacingF     =  50             ; set contour spacing

;res@cnInfoLabelOn       = True              ; displays informational label
;res@cnInfoLabelString   = "Max:"+sprintf("%3.2f",max(xab))+"  Min:"+sprintf("%3.2f",min(xab))+"  Mean: "+sprintf("%3.2f",avg(xab))

;res@lbLabelStrings     = (/"0","","0.1","","0.2","","0.3","","0.4","","0.5","","0.6"/)
res@lbBoxSeparatorLinesOn = False
res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
res@tmXTOn = False            ; turn off top   labels
res@tmYROn = False            ; turn off right labels

    plot1    = gsn_csm_contour_map(wks,xab(lat1:lat2,lon1:lon2),res)
 
;fshp_sc  = "/dfs5/apep/wuk15/shpfile/gadm36_USA_2.shp"
;  lnres                  = True
;  lnres@gsLineThicknessF =3.0
;printVarSummary(fshp_sc)
;  poly1 = gsn_add_shapefile_polylines(wks,plot1,fshp_sc,lnres)

;    printVarSummary(xab)
;    plot1    = gsn_csm_contour_map(wks,xab,res)
;    plot1    = gsn_csm_contour_map(wks,xab(lat1:lat2,lon1:lon2),res)
    draw(plot1)
    frame(wks)

    print(" ")

  print("---------------- Done!!! -------------------")
end
