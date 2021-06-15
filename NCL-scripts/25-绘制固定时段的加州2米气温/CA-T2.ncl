begin

  ts = 18   ;起始时间   ncdump查看每天小时数 然后计算自己画图时间段起始序号
  te = 23   ;结束时间
  dir   = "/GFPS8p/xyyang/wk/WRFout/2020-CA/1year/"
  fmapname = "/GFPS8p/xyyang/wk/WRFout/2020-CA/07/wrfout_d03_2020-08-01_00_00_00.nc"
  fmap = addfile(fmapname,"r")

  fname = systemfunc("ls " + dir + "wrfout_d03_2020-07*")
  fn      = fname
  f       = addfiles(fn, "r")
  xo       = f[:]->T2(ts:te,:,:) - 273.15
  printVarSummary(xo)
  xab1 = dim_avg_n_Wrap(xo, 0)

  printVarSummary(xab1)

  lat2d  = fmap->XLAT(0,:,:)
  lon2d  = fmap->XLONG(0,:,:)
  xab1@lat2d = lat2d 
  xab1@lon2d = lon2d 
  wks  = gsn_open_wks("png","2020T2")  ; send graphics to PNG file


;******To increase maximum workstation memory************
setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
end setvalues
;******End the setting for maximum workstation memory************

;  cmap     := read_colormap_file("BlAqGrYeOrReVi200")
;  cmap(0,:) = (/0,0,0,0/)    ; make first color fully transparent

  clbdft  = "BlAqGrYeOrReVi200"
  gsn_define_colormap(wks,clbdft)

res                     = True  ; plot mods desired
res@gsnDraw             = False ; turn off draw
res@gsnFrame            = False          ; don't advance frame yet
res@gsnSpreadColors     = True  ; use full range of colormap
res@cnFillOn            = True  ; color plot desired
res@cnLinesOn           = False ; turn off contour lines
res@cnLineLabelsOn      = False ; turn off contour labels
res@gsnAddCyclic        = False


res@mpOutlineOn           = True
res@mpGeophysicalLineThicknessF = 2
res@mpOutlineSpecifiers   = "conterminous us : counties"
res@mpFillAreaSpecifiers  = "conterminous us : counties"
res@mpOutlineBoundarySets = "usstates"      ; "geophysical"
res@mpFillBoundarySets    = "geophysical"
res@mpDataBaseVersion     = "MediumRes" 
res@mpDataSetName         = "Earth..4"
;res@mpDataSetName         = "/dfs5/apep/wuk15/NCL/database/Earth..4"


;******Set Projections and reference lon and lat****************
res@mpProjection        = "LambertConformal"
res@mpLambertParallel1F = 30.    ;file@TRUELAT1
res@mpLambertParallel2F = 60.    ;file@TRUELAT2
res@mpLambertMeridianF  = -120.5 ;file@STAND_LON

;******Plot mode****************
;if using grid ranges to specify the plot domain, uncomment following lines
res@mpLimitMode         = "Corners"
res@mpLeftCornerLatF    = fmap->XLAT(0,0,0)
res@mpLeftCornerLonF    = fmap->XLONG(0,0,0)
res@mpRightCornerLatF   = fmap->XLAT(0,296,326)
res@mpRightCornerLonF   = fmap->XLONG(0,296,326)

  ;******Contour mode****************
  res@pmTickMarkDisplayMode       = "Always"  ; use NCL default lat/lon labels
;  res@lbOrientation       = "Vertical"        ; vertical label bar 
  res@pmLabelBarOrthogonalPosF = 0.1          ; move label bar closer
  res@cnLevelSelectionMode= "ManualLevels"    ; set manual contour levels
  res@cnMinLevelValF      =  0.0                ; set min contour level
  res@cnMaxLevelValF      =  40.0              ; set max contour level
  res@cnLevelSpacingF     =  0.5             ; set contour spacing
  res@cnInfoLabelOn       = True              ; displays informational label
  res@cnInfoLabelString   = "Max:"+sprintf("%3.1f",max(xab1))+"  Min:"+sprintf("%3.1f",min(xab1))+"  Mean: "+sprintf("%3.1f",avg(xab1))
;  res@gsnLeftString = "(c) May 6th"
  res@lbBoxSeparatorLinesOn = False
  res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
  res@tmXTOn = False            ; turn off top   labels
  res@tmYROn = False            ; turn off right labels


  plot = gsn_csm_contour_map(wks,xab1,res)   ; Draw map, but don't advance frame.

;---Section to add polylines to map.
;  plres             = True           ; resource list for polylines
;  plres@gsLineColor = "black"
;  plres@gsLineThicknessF =2.0 
;  id = gsn_add_shapefile_polylines(wks,plot,"/GFPS8p/xyyang/wk/ncljq/shp/province.shp",plres)

  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.


end
