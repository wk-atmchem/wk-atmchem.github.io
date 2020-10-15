begin

f2 =  "/GFPS8p/xyyang/wk/ncljq/20200613_txt/2019mon3.txt"
f3 =  "/GFPS8p/xyyang/wk/ncljq/20200613_txt/2020mon3.txt"
;  data1 = new(1688960,"float")
;  data1 = asciiread(f2,-1,"float") 
  data = new((/250,350/),"float")
  data = asciiread(f2,(/250,350/),"float") 
  data1 = new((/250,350/),"float")
  data1 = asciiread(f3,(/250,350/),"float") 

  data = data1 - data
;do i = 0, 42223
;    data(i,:) = data1(i*40:40*i+39)
    ; write loop content
;end do

 ; print(zd(0,:))
printVarSummary(data)

 lat = fspan(28,33,250)
 lon = fspan(102, 109, 350)

 lat@units="degrees_north"
 lat@long_name ="latitude"
 lon@units="degrees_east"
 lon@long_name ="longitude"

 data!0="lat"
 data!1 ="lon"
 data&lat = lat
 data&lon = lon

  wks = gsn_open_wks("png","tu")

    res               = True

    res@gsnMaximize   = True   ; maximize plot in frame
        res@gsnDraw             = False ; turn off draw
        res@gsnFrame            = False          ; don't advance frame yet
;   res@tiMainString  = "Summer ISOP"
    ;res@mpProjection  = "LambertConformal"    ; The default
    res@cnFillOn      = True  
    res@cnFillPalette = "WhiteBlueGreenYellowRed"          ;change colorbar
;   res@cnFillMode = "RasterFill" 
    res@cnLinesOn     = False
   res@cnLineLabelsOn = False
    res@tmXTLabelsOn = False
    res@tmYRLabelsOn = False
    res@gsnAddCyclic  = False
    res@lbOrientation         = "Vertical"

;---Zoom in on plot
  res@mpMinLatF     = 28
  res@mpMaxLatF     = 33
  res@mpMinLonF     = 102
  res@mpMaxLonF     = 109

;  res@mpLimitMode            = "Corners"          ; choose region of map
;  res@mpLeftCornerLatF       = XLAT_I(0,50)
;  res@mpLeftCornerLonF       = XLONG_I(0,0)
;  res@mpRightCornerLatF      = XLAT_I(nlat-1,nlon-1)
;  res@mpRightCornerLonF      = XLONG_I(nlat-1,nlon-50)
;  res@mpLeftCornerLatF       = 28
;  res@mpLeftCornerLonF       = 102
;  res@mpRightCornerLatF      = 33
;  res@mpRightCornerLonF      = 109

;  res@mpProjection           = "LambertConformal"
;  res@mpLambertParallel1F    = 25
;  res@mpLambertParallel2F    = 40
;  res@mpLambertMeridianF     = 110
;---Additional resources desired
  res@pmTickMarkDisplayMode = "Always"   ; nicer tickmarks
;res@mpGeophysicalLineThicknessF = 5
;res@cnFillDrawOrder = "PreDraw"
res@mpFillColor = -1
res@mpNationalLineThicknessF=3.0
;res@mpUSStatelLineThicknessF=1.5 

;  res@lbLabelBarOn = False

  res@mpDataBaseVersion     = "MediumRes"       ; better and more map outlines
  res@mpDataSetName         = "/GFPS8p/xyyang/wk/ncl/NCL-Chinamap-master/database/Earth..4"
;  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpAreaMaskingOn            = True
;  res@mpMaskAreaSpecifiers       = (/"China"/)
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
  res@mpOutlineOn           = True
  res@mpFillDrawOrder             = "PostDraw"
  res@mpFillOn                    = True
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces","Taiwan"/)
  res@mpMaskAreaSpecifiers        = (/"China:states","Taiwan"/)
  res@mpOceanFillColor            = "white"
;res@mpInlandWaterFillColor      = "white"
  res@mpLandFillColor         = "white"          ; make land borders white
  res@mpFillBoundarySets         = "NoBoundaries"
  res@mpOutlineBoundarySets      = "NoBoundaries"

  res@tiMainOffsetYF        = -0.03           ; Move the title down

;---Change contour levels to better match the color map being used
;  res@cnLevelSelectionMode = "ExplicitLevels"
;  res@cnLevels = fspan(0,40,41)


    map= gsn_csm_contour_map(wks,data,res)

;;;;添加shp
        fshp_sc  = "/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp"
        lnres                  = True
        lnres@gsLineThicknessF =2.0
        ;printVarSummary(fshp_sc)
        poly1 = gsn_add_shapefile_polylines(wks,map,fshp_sc,lnres)
                draw(map)
                frame(wks)

end
