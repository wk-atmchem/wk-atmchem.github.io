load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
    var = PM25_TOT
    dir   = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/POST/"
    dir1   = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/POST/2019-SCB-basecase/"
 
    fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/mcip/2013-01-BASE-sichuan/GRIDCRO2D_2013100.nc"
    fmap    = addfile(fmapname,"r")

	fab = systemfunc("ls " + dir + "COMBINE_ACONC_2019SCB_201901*")
    print(fab(0))  
    day = dimsizes(fab)
    data_ab = new((/744,1,182,232/),"float")

    do dd = 0, day - 1
		ffab = addfile(fab(dd), "r")
		data_ab(dd,:,:,:,:) = ffab->$var$(ts:te,:,:,:)
	end do


    fab1 = systemfunc("ls " + dir1 + "COMBINE_ACONC_50reduce2019SCB_201901*")
    print(fab1(0))  
    day1 = dimsizes(fab1)
    data_ab1 = new((/744,1,182,232/),"float")

    do dd = 0, day1 - 1
        ffab1 = addfile(fab1(dd), "r")
        data_ab1(dd,:,:,:,:) = ffab1->$var$(ts:te,:,:,:)
    end do

    xab1 = dim_avg_n(data_ab, (/0,1/))
    xab2 = dim_avg_n(data_ab1, (/0,1/))
    xab  = xab2 - xab1

printVarSummary(xab)
;计算

    tmpab     = ndtooned(xab)
    abmean   = dim_avg(tmpab)
	wks     = gsn_open_wks("png","1")
;    wks     = gsn_open_wks("png","ab-a-b-SOA")
        clbdft  = "BlueWhiteOrangeRed"                      ; Colorbar Default
;        clbdft  = "BlueDarkRed18"
;        clbdft  = "sunshine_9lev"
  setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues
  
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
        res@mpLambertMeridianF  = 105.
        res@mpLimitMode         = "Corners"
        res@mpLeftCornerLatF    = fmap->LAT(0,0,0,0)
        res@mpLeftCornerLonF    = fmap->LON(0,0,0,0)
        res@mpRightCornerLatF   = fmap->LAT(0,0,181,231)
        res@mpRightCornerLonF   = fmap->LON(0,0,181,231)


        res@tfDoNDCOverlay       = True
        res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
        res@tmXTOn = False            ; turn off top   labels
        res@tmYROn = False            ; turn off right labels


        res@mpFillOn              = True         ; Turn on map fill
        res@mpFillBoundarySets    = "National"
        res@mpFillAreaSpecifiers  = (/"China:states"/)
        res@mpOutlineOn           = True         ; Turn on map outlines
;  res@mpOutlineSpecifiers   = (/"China:states"/)
                                               ; commented 5/17/2007
        res@tfDoNDCOverlay        = True             ; True for 'native' grid
                                               ; some WRF are not native

        res@mpNationalLineThicknessF    = 3.0
;  res@mpGeophysicalLineThicknessF = 4.0
        res@pmTickMarkDisplayMode       = "Always"
        res@lbOrientation       = "Vertical"
	    res@gsnMaximize        = True
;        res@cnInfoLabelOn       = True
;        res@cnInfoLabelOrthogonalPosF = -0.04
;        res@cnInfoLabelString   = "Max:"+max(xab)+"   Min:"+min(xab)+"  Mean: "+avg(xab)
;        res@cnInfoLabelString    = "Max:"+sprintf("%3.1f",max(xab))+"  Min:"+sprintf("%3.1f",min(xab))+"  Mean: "+sprintf("%3.1f",avg(xab))
        res@cnLevelSelectionMode= "ManualLevels"
        res@cnMinLevelValF      = -30
        res@cnMaxLevelValF      = 30
        res@cnLevelSpacingF     = 0.2
		res@mpDataBaseVersion     = "MediumRes"  ; Medium resolution database

;              res@tiMainString        = plottitle
		res@tiMainFontHeightF	= 0.028
		res@tiDeltaF		= 1 
;                        res@gsnLeftString       = lefttitle
 ;       res@gsnRightString      = righttitle
;		res@gsnLeftStringFontHeightF = 18
;		res@gsnRightStringFontHeightF = 18
;res@tiMainString        = plottitle1

;    res@cnInfoLabelString   = "Max: $ZMX$   Min: $ZMN$" 
    printVarSummary(xab)
    plot1    = gsn_csm_contour_map(wks,xab,res)
;    res@gsnLeftString       = ""
;    res@gsnRightString      = ""

;    draw(plot1)
;    frame(wks)
;  fshp_c  = "/GFPS8p/xyyang/wk/ncljq/shp/city.shp"
  fshp_sc  = "/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp"
  lnres                  = True
  lnres@gsLineThicknessF =2.0
printVarSummary(fshp_sc)
  poly1 = gsn_add_shapefile_polylines(wks,plot1,fshp_sc,lnres)


    draw(plot1)
    frame(wks)

    print(" ")

  print("---------------- Done!!! -------------------")
end
