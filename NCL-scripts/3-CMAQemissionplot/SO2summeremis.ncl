load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

  months	= (/"01","06"/) ;月份通过循环mm控制
  types        = (/"bio/","nobio/","onlybio/"/)   ;类型case通过循环tt控制
  var          = (/"SO2","SOA"/);变量通过循环xx控制

  dir   = "/GFPS8p/xyyang/wk/NH3/0817emisplot/summer/"
;地理信息
  fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/mcip/2017-01-BASE/GRIDCRO2D_2017001.nc"
  fmap    = addfile(fmapname,"r")
do mm = 1, 1
do tt = 0, 0  ;;;不用调
do vv = 0, 0

  units		= (/"mol/s","mol/s"/)
  righttitle    = units(vv)+"    "+"SO~B~2~N~"
; lefttitle     = var(vv)
;fab表示a和b;fa表示a;fb表示b路径
;计算数据 xab，xa，xb
	fab = systemfunc("ls " + dir + "EM_2017*")
    print(fab(0))  
    day1 = dimsizes(fab)
    data_ab = new((/62,25,14,182,232/),"float")
      
    if (vv .eq. 0) then
    	do dd = 0, day1 - 1
			ffab = addfile(fab(dd), "r")
			printVarSummary(ffab->$var$)
			print(dd)
			data_ab(dd,:,:,:,:) = ffab->$var$(:,:,:,:)
		end do
		xab = dim_avg_n(dim_max_n(data_ab, (/1,2/)), 0)

	end if

printVarSummary(xab)
;计算

        tmpab     = ndtooned(xab)
        abmean   = dim_avg(tmpab)
      

;;;;画图
    fon   = var(vv) + months(mm)
	wks     = gsn_open_wks("png",fon)
;    wks     = gsn_open_wks("png","ab-a-b-SOA")
        clbdft  = "BlAqGrYeOrReVi200"                      ; Colorbar Default
;        clbdft  = "BlueDarkRed18"
;        clbdft  = "sunshine_9lev"
  setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues
		
		lon1 = 0   ;;;修改画图左下角和右上角格点数  1左下  2右上   0-231
		lon2 = 200  ;;;  lon1-231
		lat1 = 20   ;;;  0-181
		lat2 = 180  ;;;  lat1-181
		
        gsn_define_colormap(wks,clbdft)

        res                     = True	; plot mods desired
        res@gsnDraw             = False	; turn off draw
        res@gsnFrame            = False          ; don't advance frame yet
        res@gsnSpreadColors     = True	; use full range of colormap
        res@cnFillOn            = True	; color plot desired
        res@cnLinesOn           = False ; turn off contour lines
        res@cnLineLabelsOn      = False ; turn off contour labels

        res@tfDoNDCOverlay              = True
        res@mpGeophysicalLineThicknessF = 2
        res@mpOutlineBoundarySets       = "National"
	    res@mpDataSetName         = "Earth..4"   ; This new database contains
                                           ; divisions for other countries.
        res@mpGridAndLimbOn             = True
        res@mpGridLineDashPattern       = 2
        res@tmXTOn                      = False
        res@tmYROn                      = False



res@mpProjection        = "LambertConformal"
res@mpLambertParallel1F = 25.
res@mpLambertParallel2F = 40.
res@mpLambertMeridianF  = 110.
res@mpLimitMode         = "Corners"
res@mpLeftCornerLatF    = fmap->LAT(0,0,lat1,lon1)
res@mpLeftCornerLonF    = fmap->LON(0,0,lat1,lon1)
res@mpRightCornerLatF   = fmap->LAT(0,0,lat2,lon2)
res@mpRightCornerLonF   = fmap->LON(0,0,lat2,lon2)

res@tfDoNDCOverlay       = True
  res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
  res@tmXTOn = False            ; turn off top   labels
  res@tmYROn = False            ; turn off right labels


res@mpDataBaseVersion     = "MediumRes"       ; better and more map outlines
  res@mpDataSetName         = "/GFPS8p/xyyang/wk/ncl/NCL-Chinamap-master/database/Earth..4"
;  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpAreaMaskingOn            = True
;  res@mpMaskAreaSpecifiers       = (/"China"/)
;  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
  res@mpOutlineOn           = True
  res@mpFillDrawOrder             = "PostDraw"
  res@mpFillOn                    = True
;  res@mpOutlineSpecifiers        = (/"China","Taiwan"/)
  res@mpOutlineSpecifiers        = (/"China","China:Provinces","Taiwan"/)
  res@mpMaskAreaSpecifiers        = (/"China:states","Taiwan"/)

res@mpOceanFillColor            = "white"
res@mpInlandWaterFillColor      = "white"
  res@mpLandFillColor         = "white"          ; make land borders white
  res@mpFillBoundarySets         = "NoBoundaries"
  res@mpOutlineBoundarySets      = "NoBoundaries"




;old set up
;  res@mpFillOn              = True         ; Turn on map fill
;  res@mpFillBoundarySets    = "National"
;  res@mpFillAreaSpecifiers  = (/"China:states"/)
;  res@mpOutlineOn           = True         ; Turn on map outlines
;  res@mpOutlineSpecifiers   = (/"China:states"/)  ; commented 5/17/2007
;   res@tfDoNDCOverlay        = True             ; True for 'native' grid

  res@mpNationalLineThicknessF    = 3.0
;  res@mpGeophysicalLineThicknessF = 4.0
                res@pmTickMarkDisplayMode       = "Always"
                res@lbOrientation       = "Vertical"
	res@gsnMaximize        = True
;                res@cnInfoLabelOn       = True
                res@cnInfoLabelOrthogonalPosF = -0.04
                res@cnLevelSelectionMode= "ManualLevels"
                res@cnMinLevelValF      = 0.0
                res@cnMaxLevelValF      = 4.0
                res@cnLevelSpacingF     = 0.1
if (vv .eq. 1 ) then
                res@cnMinLevelValF      = 0
                res@cnMaxLevelValF      = 2
                res@cnLevelSpacingF     = 0.1
end if
;                res@cnMinLevelValF      = MinF
;                res@cnMaxLevelValF      = MaxF
;                res@cnLevelSpacingF     = SpaceF
;                res@lbLabelStride       = 10
		res@mpDataBaseVersion     = "MediumRes"  ; Medium resolution database

;                res@tiMainString        = plottitle
		res@tiMainFontHeightF	= 0.028
		res@tiDeltaF		= 1 
;                        res@gsnLeftString       = lefttitle
                        res@gsnRightString      = righttitle
;		res@gsnLeftStringFontHeightF = 18
;		res@gsnRightStringFontHeightF = 18
;res@tiMainString        = plottitle1

;    res@cnInfoLabelString   = "Max:"+sprintf("%4.2f",max(xab))+"   Min:"+sprintf("%4.2f",min(xab))+"  Mean: "+sprintf("%4.2f",avg(xab)) 
    printVarSummary(xab)
    plot1    = gsn_csm_contour_map(wks,xab(lat1:lat2,lon1:lon2),res)
;    res@gsnLeftString       = ""
;    res@gsnRightString      = ""
    draw(plot1)
    frame(wks)

    print(" ")


  end do
  end do
  end do
  print("---------------- Done!!! -------------------")
end
