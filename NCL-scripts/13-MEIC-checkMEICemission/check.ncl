begin
	year	= 2020
	stday	= 107      ;   87,177,269
	month   = "09"
	case    = "BASE"
	julday	= year * 1000 + stday       ;2017000+177=2017177
	
    fa0    = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+""
	fa1	   = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+"_tra"         ;EM_M_03_08CHINA_2017131_ind
	fa2    = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+"_agr"
    fa3    = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+"_pow"
    fa4    = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+"_res"
    fa5    = "/GFPS8p/xyyang/wk/emis/emis_wukai/output/EM_M_03_08CHINA_"+julday+"_ind"
    f1 = addfile(fa1,"r")
    f2 = addfile(fa2,"r")
    f3 = addfile(fa3,"r")
    f4 = addfile(fa4,"r")
    f5 = addfile(fa5,"r")

    f11 = fa1->NO2 + fa2->NO2 + fa3->NO2 + fa4->NO2 + fa5->NO2    
    f12 = fa0->NO2

    f13 = f11(0,:,:,:) -f12(0,:,:,:)
    fmap = addfile("/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/mcip/2020-04-BASE-sichuan/GRIDCRO2D_2020116.nc","r")
    xxab_a = f13
    xxab_a@lat2d = fmap->LAT(0,0,:,:)
    xxab_a@lon2d = fmap->LON(0,0,:,:)

;******Print the information of the variable****************
printVarSummary(xxab_a)

;******Set the name for the output figure****************
fon   = (/"plot"/)
;        wks_type = "png"
;        wks_type@wkWidth = 1600
;        wks_type@wkHeight = 1600 
wks     = gsn_open_wks("png", fon)

;******To increase maximum workstation memory************
setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
end setvalues
;******End the setting for maximum workstation memory************

;******Define colormap used for the plot****************
clbdft  = "WhiteBlueGreenYellowRed"
gsn_define_colormap(wks,clbdft)
;******End colormap definition used for the plot****************

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
res@mpOutlineSpecifiers   = (/"China:states"/)
res@mpFillAreaSpecifiers  = (/"China:states"/)
res@mpOutlineBoundarySets = "National"
res@mpFillBoundarySets    = "geophysical"
res@mpDataBaseVersion     = "MediumRes" 

;******Set Projections and reference lon and lat****************
res@mpProjection        = "LambertConformal"
res@mpLambertParallel1F = 25.    ;file@TRUELAT1
res@mpLambertParallel2F = 40.    ;file@TRUELAT2
res@mpLambertMeridianF  = 105 ;file@STAND_LON

;******Plot mode****************
;if using grid ranges to specify the plot domain, uncomment following lines
res@mpLimitMode         = "Corners"
res@mpLeftCornerLatF    = fmap->LAT(0,0,0,0)
res@mpLeftCornerLonF    = fmap->LON(0,0,0,0)
res@mpRightCornerLatF   = fmap->LAT(0,0,181,231)
res@mpRightCornerLonF   = fmap->LON(0,0,181,231)

;if using longitudes/latitudes ranges to specify the plot domain, uncomment following lines
;res@mpLimitMode         = "LatLon"
;res@mpMinLatF           = 34.5     ; map area
;res@mpMaxLatF           = 38.5         ; latitudes
;res@mpMinLonF           = -122.      ; and
;res@mpMaxLonF           = -118.        ; longitudes
;******Plot mode selection end****************

;******Contour mode****************
res@pmTickMarkDisplayMode       = "Always"  ; use NCL default lat/lon labels
res@lbOrientation       = "Vertical"        ; vertical label bar 
res@pmLabelBarOrthogonalPosF = 0.1          ; move label bar closer
res@gsnMaximize        = True               ; maximize the plot
res@cnLevelSelectionMode= "ManualLevels"    ; set manual contour levels
res@cnMinLevelValF      =  -4.0                ; set min contour level
res@cnMaxLevelValF      =  4.0              ; set max contour level
res@cnLevelSpacingF     =  0.1             ; set contour spacing

res@cnInfoLabelOn       = True              ; displays informational label
res@cnInfoLabelString   = "Max:"+sprintf("%3.2f",max(xxab_a))+"  Min:"+sprintf("%3.2f",min(xxab_a))+"  Mean: "+sprintf("%3.2f",avg(xxab_a))

;res@lbLabelStrings = (/"0","","0.1","","0.2","","0.3","","0.4","","0.5","","0.6"/)
res@lbBoxSeparatorLinesOn = False
res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
res@tmXTOn = False            ; turn off top   labels
res@tmYROn = False            ; turn off right labels

res@tiMainString = "NO2 check"    ; set main title of the figure
res@tiMainFont          = 22
res@tiMainFontHeightF   = 0.028
res@tiDeltaF        = 1 

plot1    = gsn_csm_contour_map(wks,xxab_a,res)
draw(plot1)
frame(wks)

print(" ")
print("---------------- Done!!! -------------------")

end 