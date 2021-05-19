begin

  ts = 16  ;起始时间   ncdump查看每天小时数 然后计算自己画图时间段起始序号
  te = 17   ;结束时间
  totalT = te-ts+1
  dir   = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/PREP/mcip/WRF_LINK/2016-08-BASE-sichuan/"
  fmapname = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/PREP/mcip/WRF_LINK/2016-08-BASE-sichuan/wrfout_d01_2016-07-29_00:00:00.nc"
  fmap = addfile(fmapname,"r")

  fn = systemfunc("ls " + dir + "wrfout_d01_2016-07*")

  day1   = dimsizes(fn)
  data_ab = new((/day1,totalT,194,244/),"float")

  do dd = 0, day1 - 1 
   f       = addfile(fn(dd), "r")
   rh2     = wrf_user_getvar(f,"rh2",-1)
   printVarSummary(rh2)
   data_ab(dd,:,:,:) = rh2(ts:te,:,:) 
  end do

  xab1 = dim_avg_n(data_ab, (/0,1/))

  printVarSummary(xab1)

  lat2d  = fmap->XLAT(0,:,:)
  lon2d  = fmap->XLONG(0,:,:)
  xab1@lat2d = lat2d 
  xab1@lon2d = lon2d 
  wks  = gsn_open_wks("png","RH2")  ; send graphics to PNG file


;******To increase maximum workstation memory************
setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
end setvalues
;******End the setting for maximum workstation memory************

  cmap     := read_colormap_file("BlAqGrYeOrReVi200")
  cmap(0,:) = (/0,0,0,0/)    ; make first color fully transparent

  res                     = True
  res@gsnDraw             = False          ; don't draw plot yet
  res@gsnAddCyclic        = False
  res@gsnFrame            = False          ; don't advance frame yet
  res@gsnMaximize         = True           ; maximize plot in frame
  res@mpDataBaseVersion   = "MediumRes"    ; slightly better resolution

  res@cnFillOn              = True             ; color plot desired
  ; res_ter@cnFillPalette         = "gsltod"         ; Select grayscale colormap
  res@cnLinesOn             = False            ; turn off contour lines
  res@cnLineLabelsOn        = False            ; turn off contour labels
  res@cnFillMode            = "RasterFill"
  res@cnFillPalette        = cmap
; Zoom in on South America.
;  res@mpMinLatF           = 28.4
;  res@mpMaxLatF           = 32.3
;  res@mpMinLonF           = 102.7
;  res@mpMaxLonF           = 107.8
  res@mpProjection        = "LambertConformal"
  res@mpLambertParallel1F = 25.    ;file@TRUELAT1
  res@mpLambertParallel2F = 40.    ;file@TRUELAT2
  res@mpLambertMeridianF  = 105. ;file@STAND_LON

  res@mpLimitMode         = "Corners"
  res@mpLeftCornerLatF    = fmap->XLAT(0,0,0)
  res@mpLeftCornerLonF    = fmap->XLONG(0,0,0)
  res@mpRightCornerLatF   = fmap->XLAT(0,193,243)
  res@mpRightCornerLonF   = fmap->XLONG(0,193,243)

  ;******Contour mode****************
  res@pmTickMarkDisplayMode       = "Always"  ; use NCL default lat/lon labels
;  res@lbOrientation       = "Vertical"        ; vertical label bar 
  res@pmLabelBarOrthogonalPosF = 0.1          ; move label bar closer
  res@cnLevelSelectionMode= "ManualLevels"    ; set manual contour levels
  res@cnMinLevelValF      =  60                ; set min contour level
  res@cnMaxLevelValF      =  100.0              ; set max contour level
  res@cnLevelSpacingF     =  0.5             ; set contour spacing
;  res@cnInfoLabelOn       = True              ; displays informational label
;  res@cnInfoLabelString   = "Max:"+sprintf("%3.1f",max(xab1))+"  Min:"+sprintf("%3.1f",min(xab1))+"  Mean: "+sprintf("%3.1f",avg(xab1))
;  res@gsnLeftString = "(c) May 6th"
  res@lbBoxSeparatorLinesOn = False
  res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
  res@tmXTOn = False            ; turn off top   labels
  res@tmYROn = False            ; turn off right labels


  plot = gsn_csm_contour_map(wks,xab1,res)   ; Draw map, but don't advance frame.

;---Section to add polylines to map.
  plres             = True           ; resource list for polylines
  plres@gsLineColor = "black"
  plres@gsLineThicknessF =2.0 
  id = gsn_add_shapefile_polylines(wks,plot,"/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp",plres)

  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.


end
