begin

f2 =  "./2019mon2.txt"
;f3 =  "/GFPS8p/xyyang/wk/ncljq/20200613_txt/2020mon3.txt"
;  data1 = new(1688960,"float")
;  data1 = asciiread(f2,-1,"float") 
  data = new((/1000,1200/),"float")
  data = asciiread(f2,(/1000,1200/),"float") 
;  data1 = new((/250,350/),"float")
;  data1 = asciiread(f3,(/250,350/),"float") 

;  data = data1 - data
;do i = 0, 42223
;    data(i,:) = data1(i*40:40*i+39)
    ; write loop content
;end do

 ; print(zd(0,:))
printVarSummary(data)

 lat = fspan(17.5,27.5,1000)
 lon = fspan(107.5,119.5,1200)

 lat@units="degrees_north"
 lat@long_name ="latitude"
 lon@units="degrees_east"
 lon@long_name ="longitude"

 data!0="lat"
 data!1 ="lon"
 data&lat = lat
 data&lon = lon

 fout = addfile("2019mon2.nc","c")
 fout->NO2 = data
 fout->longitude = lon
 fout->latitude  = lat

wks = gsn_open_wks("png","PRDno2")

    res               = True

    res@gsnMaximize   = True   ; maximize plot in frame
    res@gsnDraw         = False
    res@gsnFrame        = False
    res@tiMainString  = "TROPOMI NO~B~2~N~ VCD 2020"
    ;res@mpProjection  = "LambertConformal"    ; The default
    res@cnFillOn      = True  
    res@cnFillPalette = "BlAqGrYeOrReVi200"
;    res@cnFillPalette = "BlAqGrYeOrReVi200"          ;change colorbar
    res@gsnSpreadColors = True ; use full color map
    res@gsnSpreadColorStart = 10
    res@gsnSpreadColorEnd = 199
    res@cnFillMode = "RasterFill" 
    res@cnLinesOn     = False
    res@cnLineLabelsOn = False
    res@tmXTLabelsOn = False
    res@tmYRLabelsOn = False
    res@gsnAddCyclic  = False
    res@lbOrientation         = "Vertical"

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
  res@mpLeftCornerLatF       = 17.5
  res@mpLeftCornerLonF       = 107.5
  res@mpRightCornerLatF      = 27.5
  res@mpRightCornerLonF      = 119.5
  res@mpProjection           = "LambertConformal"
  res@mpLambertParallel1F    = 25
  res@mpLambertParallel2F    = 40
  res@mpLambertMeridianF     = 113.5
;---Additional resources desired
  res@pmTickMarkDisplayMode = "Always"   ; nicer tickmarks
res@mpGeophysicalLineThicknessF = 2
;res@cnFillDrawOrder = "PreDraw"
res@mpFillColor = -1
res@mpNationalLineThicknessF=3.0
;res@mpUSStatelLineThicknessF=1.5 

;  res@lbLabelBarOn = False

    res@mpOutlineSpecifiers   = "conterminous us : counties"
    res@mpFillAreaSpecifiers  = "conterminous us : counties"
    res@mpOutlineBoundarySets = "usstates"      ; "geophysical"
    res@mpFillBoundarySets    = "geophysical"
    res@tmXTOn=False
    res@tmXTLabelsOn = False 
    res@tmYROn=False 
    res@tmYRLabelsOn = False 
    res@mpDataBaseVersion     = "MediumRes"       ; better and more map outlines
    res@mpDataSetName         = "Earth..4"
;  res@mpOutlineBoundarySets = "AllBoundaries"
;  res@mpAreaMaskingOn            = True
;  res@mpMaskAreaSpecifiers       = (/"China"/)
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
    res@mpOutlineOn           = True
;  res@mpFillDrawOrder             = "PostDraw"
    res@mpFillOn                    = True
    res@mpFillOn                    = False
;  res@mpOutlineSpecifiers        = (/"China","Taiwan"/)
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces","Taiwan"/)
;  res@mpMaskAreaSpecifiers        = (/"China:states","Taiwan"/)

    res@mpOceanFillColor            = "white"
    res@mpInlandWaterFillColor      = "white"
;  res@mpLandFillColor         = "white"          ; make land borders white
;  res@mpFillBoundarySets         = "NoBoundaries"
;  res@mpOutlineBoundarySets      = "NoBoundaries"
;  res@mpFillBoundarySets         = "National"
;  res@mpOutlineBoundarySets      = "National"

    res@tiMainOffsetYF        = -0.01           ; Move the title down


;---Change contour levels to better match the color map being used
;  res@cnLevelSelectionMode = "ExplicitLevels"
;  res@cnLevels = fspan(0,2000,51)
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF = 0
    res@cnMaxLevelValF = 6
    res@cnLevelSpacingF = 0.05
    res@lbLabelStride = 20
    map= gsn_csm_contour_map(wks,data,res)
    draw(map)
    frame(wks)
end
