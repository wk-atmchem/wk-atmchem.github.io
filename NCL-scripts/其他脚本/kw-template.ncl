;************Written by Kai Wu************
;****University of California, Irvine*****
;************All rights reserved**********
;*******Contact wukaicuit@gmail.com*******
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin 
fmap = addfile("/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2012-06-BASE/GRIDCRO2D_2012160.nc","r")
ff = addfile("/dfs5/apep/wuk15/tst.nc","r")
ss = ff->xxab

xxab_a = ff->xxab
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

res                     = True	; plot mods desired
res@gsnDraw             = False	; turn off draw
res@gsnFrame            = False          ; don't advance frame yet
res@gsnSpreadColors     = True	; use full range of colormap
res@cnFillOn            = True	; color plot desired
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
res@mpDataSetName         = "/dfs5/apep/wuk15/NCL/database/Earth..4"


;******Set Projections and reference lon and lat****************
res@mpProjection        = "LambertConformal"
res@mpLambertParallel1F = 30.    ;file@TRUELAT1
res@mpLambertParallel2F = 60.    ;file@TRUELAT2
res@mpLambertMeridianF  = -120.5 ;file@STAND_LON

;******Plot mode****************
;if using grid ranges to specify the plot domain, uncomment following lines
res@mpLimitMode         = "Corners"
res@mpLeftCornerLatF    = fmap->LAT(0,0,0,0)
res@mpLeftCornerLonF    = fmap->LON(0,0,0,0)
res@mpRightCornerLatF   = fmap->LAT(0,0,269,296)
res@mpRightCornerLonF   = fmap->LON(0,0,269,296)

;if using longitudes/latitudes ranges to specify the plot domain, uncomment following lines
;res@mpLimitMode		 = "LatLon"
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
res@cnMinLevelValF      =  0                ; set min contour level
res@cnMaxLevelValF      =  0.6              ; set max contour level
res@cnLevelSpacingF     =  0.01             ; set contour spacing

res@cnInfoLabelOn       = True              ; displays informational label
res@cnInfoLabelString   = "Max:"+sprintf("%3.2f",max(xxab_a))+"  Min:"+sprintf("%3.2f",min(xxab_a))+"  Mean: "+sprintf("%3.2f",avg(xxab_a))

;res@lbLabelStrings	= (/"0","","0.1","","0.2","","0.3","","0.4","","0.5","","0.6"/)
res@lbBoxSeparatorLinesOn = False
res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
res@tmXTOn = False            ; turn off top   labels
res@tmYROn = False            ; turn off right labels

res@tiMainString = "Secondary PM / total PM in 2035"    ; set main title of the figure
res@tiMainFont          = 22
res@tiMainFontHeightF   = 0.028
res@tiDeltaF        = 1 

plot1    = gsn_csm_contour_map(wks,xxab_a,res)
draw(plot1)
frame(wks)

print(" ")
print("---------------- Done!!! -------------------")

end 
