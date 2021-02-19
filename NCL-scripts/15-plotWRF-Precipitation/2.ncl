begin
  
  f0 = addfile("/GFPS8p/xyyang/wk/CMAQ-5.2.1/PREP/mcip/WRF_LINK/2020-04-BASE-sichuan/wrfout_d01_2020-05-06_00:00:00","r")
  
  Times = f0->Times 
  dims = dimsizes(Times)
  
  RAINC = f0->RAINC(0,:,:)
  RAINNC = f0->RAINNC(0,:,:)
  RainTotal = RAINC(:,:)

  istart = 2 
  iend   = 8

  RainTotal = (/(f0->RAINC(iend,:,:) + f0->RAINNC(iend,:,:) - \
                  (f0->RAINC(istart,:,:) + f0->RAINNC(istart,:,:)))/1. /)

  lat2d  = f0->XLAT(0,:,:)
  lon2d  = f0->XLONG(0,:,:)
  RainTotal@lat2d = lat2d 
  RainTotal@lon2d = lon2d 
  wks  = gsn_open_wks("png","2")  ; send graphics to PNG file

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
  res@mpMinLatF           = 28.4
  res@mpMaxLatF           = 32.3
  res@mpMinLonF           = 102.7
  res@mpMaxLonF           = 107.8

  ;******Contour mode****************
  res@pmTickMarkDisplayMode       = "Always"  ; use NCL default lat/lon labels
;  res@lbOrientation       = "Vertical"        ; vertical label bar 
  res@pmLabelBarOrthogonalPosF = 0.1          ; move label bar closer
  res@cnLevelSelectionMode= "ManualLevels"    ; set manual contour levels
  res@cnMinLevelValF      =  0                ; set min contour level
  res@cnMaxLevelValF      =  30.0              ; set max contour level
  res@cnLevelSpacingF     =  0.5             ; set contour spacing
  res@cnInfoLabelOn       = True              ; displays informational label
  res@cnInfoLabelString   = "Max:"+sprintf("%3.1f",max(RainTotal))+"  Min:"+sprintf("%3.1f",min(RainTotal))+"  Mean: "+sprintf("%3.1f",avg(RainTotal))
  res@gsnLeftString = "(c) May 6th"
  res@lbBoxSeparatorLinesOn = False
  res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
  res@tmXTOn = False            ; turn off top   labels
  res@tmYROn = False            ; turn off right labels


  plot = gsn_csm_contour_map(wks,RainTotal,res)   ; Draw map, but don't advance frame.

;---Section to add polylines to map.
  plres             = True           ; resource list for polylines
  plres@gsLineColor = "black"
  plres@gsLineThicknessF =2.0 
  id = gsn_add_shapefile_polylines(wks,plot,"/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp",plres)

  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.


end
