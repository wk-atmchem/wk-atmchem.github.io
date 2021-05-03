begin

f1  =        "/GFPS8p/xyyang/wk/ncljq/TROPOMI/no2_201812.asc"   ;
f2 =        "/GFPS8p/xyyang/wk/ncljq/TROPOMI/no2_201901.asc"
f3 =        "/GFPS8p/xyyang/wk/ncljq/TROPOMI/no2_201902.asc"

data_all = asciiread(f1, -1, "string")
data_all22 = asciiread(f2, -1, "string")
data_all33 = asciiread(f3, -1, "string")
printVarSummary(data_all)
printVarSummary(data_all22)
printVarSummary(data_all33)

data1 = data_all(:207359) ;;除去英文批注
data22 = data_all22(:207359)
data33 = data_all33(:207359)

do i = 0, 1439
    data1(i*144:143+i*144) = data_all(5+145*i:148+145*i)
    data22(i*144:143+i*144) = data_all22(5+145*i:148+145*i)
    data33(i*144:143+i*144) = data_all33(5+145*i:148+145*i) 
    ; write loop content
end do

;print(data1(122830:122832))

;data2 = new((/20,207360/),"float",-999)
data2 = new((/207360,20/),"float",-999)
data222 = new((/207360,20/),"float",-999)
data333 = new((/207360,20/),"float",-999)

do i = 0, 19
    data2(:,i) = tofloat(str_get_cols(data1, i*4, 3+i*4))
    data222(:,i) = tofloat(str_get_cols(data22, i*4, 3+i*4))
    data333(:,i) = tofloat(str_get_cols(data33, i*4, 3+i*4))
end do

  data = new((/1440,2880/),"float")
  datanew2 = new((/1440,2880/),"float")
  datanew3 = new((/1440,2880/),"float")

do i = 0, 1439
    data_hang = ndtooned(data2(144*i:143+144*i,:))
    data(i,:) = data_hang
end do

do i = 0, 1439
    data_hang = ndtooned(data222(144*i:143+144*i,:))
    datanew2(i,:) = data_hang
end do

do i = 0, 1439
    data_hang = ndtooned(data333(144*i:143+144*i,:))
    datanew3(i,:) = data_hang
end do

;data_1 = data(720:,1440:)/6.02214  ;convert the unit to umol/m2
data_1 = data(720:,1440:)/100       ;convert the unit to 10^15molec/m2
data_new2 = datanew2(720:,1440:)/100
data_new3 = datanew3(720:,1440:)/100
 ; print(zd(0,:))
printVarSummary(data_1)
printMinMax(data_1, 1)
data_1@_FillValue = -999
data_new2@_FillValue = -999
data_new3@_FillValue = -999

;calculate seasonal average
data_1 = (data_1+data_new2+data_new3)/3

 lon = fspan(0.0625, 179.9375, 1440)
 lat = fspan(0.0625, 89.9375, 720)

; lon = fspan(0.125, 179.875, 720)
; lat = fspan(0.125, 89.875, 360)

 lat@units="degrees_north"
 lat@long_name ="latitude"
 lon@units="degrees_east"
 lon@long_name ="longitude"

printVarSummary(lat)
print(lat(:10))

data_1!0 = "lat"
data_1!1 = "lon"

data_1&lat=lat
data_1&lon=lon
data_1&lat@units="degrees_north"
data_1&lon@units="degrees_east"
printVarSummary(data_1)

  wks = gsn_open_wks("png","wk-no2")

    res               = True
;    righttitle    = "~F33~m"+"mol/m2"
    res@gsnMaximize   = True   ; maximize plot in frame
  res@gsnDraw         = False
  res@gsnFrame        = False
;   res@tiMainString  = "TROPOMI NO~B~2~N~ VCD 2019 January"
    ;res@mpProjection  = "LambertConformal"    ; The default
    res@cnFillOn      = True  
           
   res@cnFillPalette = "BlAqGrYeOrReVi200"          ;change colorbar
;   res@cnFillPalette = "WhiteBlueGreenYellowRed" 
   res@gsnSpreadColors = True ; use full color map
  res@gsnSpreadColorStart = 10
  res@gsnSpreadColorEnd = 199 
  res@lbBoxSeparatorLinesOn = False
  res@cnFillMode = "RasterFill" 
    res@cnLinesOn     = False
   res@cnLineLabelsOn = False
    res@tmXTLabelsOn = False
    res@tmYRLabelsOn = False
    res@gsnAddCyclic  = False
  ;  res@lbOrientation         = "Vertical"

;---Zoom in on plot
;  res@mpMinLatF     = min(lat_cz)
;  res@mpMaxLatF     = max(lat_cz)
;  res@mpMinLonF     = min(lon_cz)
;  res@mpMaxLonF     = max(lon_cz)

  res@mpLimitMode            = "Corners"          ; choose region of map
;  res@mpLeftCornerLatF       = XLAT_I(0,50)
;  res@mpLeftCornerLonF       = XLONG_I(0,0)
;  res@mpRightCornerLatF      = XLAT_I(nlat-1,nlon-1)
;  res@mpRightCornerLonF      = XLONG_I(nlat-1,nlon-50)
  res@mpLeftCornerLatF       = 12
  res@mpLeftCornerLonF       = 81
  res@mpRightCornerLatF      = 52
  res@mpRightCornerLonF      = 140



  res@mpProjection           = "LambertConformal"
  res@mpLambertParallel1F    = 25
  res@mpLambertParallel2F    = 40
  res@mpLambertMeridianF     = 110
;---Additional resources desired
  res@pmTickMarkDisplayMode = "Always"   ; nicer tickmarks
;res@mpGeophysicalLineThicknessF = 5
;res@cnFillDrawOrder = "PreDraw"
res@mpFillColor = -1
res@mpNationalLineThicknessF=3.0
;res@mpUSStatelLineThicknessF=1.5 
res@lbTitleString = "NO~B~2~N~ vertical column density (10~S~15~N~ molec/cm~S~2~N~)" ; give the labelbar a title
res@lbTitleFontHeightF = 0.018
res@lbTitlePosition = "Bottom"
;  res@pmLabelBarHeightF = 0.60
;  res@lbLabelBarOn = False
;  res@pmLabelBarWidthF       = 0.30
  res@mpDataBaseVersion     = "MediumRes"       ; better and more map outlines
  res@mpDataSetName         = "/GFPS8p/xyyang/wk/ncl/NCL-Chinamap-master/database/Earth..4"
;  res@mpOutlineBoundarySets = "AllBoundaries"
;  res@mpAreaMaskingOn            = True
;  res@mpMaskAreaSpecifiers       = (/"China"/)
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
  res@mpOutlineOn           = True
  res@mpFillDrawOrder             = "PostDraw"
  res@mpFillOn                    = True
    res@mpFillOn                    = False
;  res@mpOutlineSpecifiers        = (/"China","Taiwan"/)
  res@mpOutlineSpecifiers        = (/"China","China:Provinces","Taiwan"/)
  res@mpMaskAreaSpecifiers        = (/"China:states","Taiwan"/)
;  res@gsnRightString      = righttitle
res@mpOceanFillColor            = "white"
res@mpInlandWaterFillColor      = "white"
;  res@mpLandFillColor         = "white"          ; make land borders white
;  res@mpFillBoundarySets         = "NoBoundaries"
;  res@mpOutlineBoundarySets      = "NoBoundaries"
  res@mpFillBoundarySets         = "National"
  res@mpOutlineBoundarySets      = "National"
;  res@mpNationalLineThicknessF   = 1.5
  res@mpProvincialLineThicknessF = 2.0
;  res@tiMainOffsetYF        = -0.03           ; Move the title down
  res@lbBoxMinorExtentF = 0.20
  res@tmXTOn=False
  res@tmYROn=False
;---Change contour levels to better match the color map being used
;  res@cnLevelSelectionMode = "ExplicitLevels"
;  res@cnLevels = fspan(0,250,9)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF = 0
  res@cnMaxLevelValF = 20
  res@cnLevelSpacingF =0.2
;  res@lbBoxEndCapStyle     = "TriangleBothEnds"
    map = gsn_csm_contour_map(wks,data_1,res)


;  fshp_c  = "/GFPS8p/xyyang/wk/ncljq/shp/city.shp"
;  fshp_gd  = "/GFPS8p/xyyang/wk/ncljq/shp/guangdong.shp"
;  lnres                  = True
;  lnres@gsLineThicknessF =3.0

;  poly1 = gsn_add_shapefile_polylines(wks,map,fshp_c,lnres)
;  poly2 = gsn_add_shapefile_polylines(wks,map,fshp_gd,lnres)
                draw(map)
                frame(wks)
end
