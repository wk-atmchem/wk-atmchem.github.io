;Written by Kai Wu, UC Irvine, September, 2020
; contact wukaicuit@gmail.com
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


ts = 0    ;起始时间   ncdump查看每天小时数 然后计算自己画图时间段起始序号
te = 23   ;结束时间


    months	= (/"06","06"/) ;月份通过循环mm控制
    types        = (/"bio/","nobio/","onlybio/"/)   ;类型case通过循环tt控制
    var          = (/"NO2_BCO","SOA"/);变量通过循环xx控制

    dir   = "./"
;地理信息
    fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/mcip/2017-01-BASE-sichuan/GRIDCRO2D_2017010.nc"
    fmap    = addfile(fmapname,"r")

    units		= (/"~F33~m"+"~F25~g/m~S1~3","micrograms/m~S1~3"/)
    righttitle    = units(vv)+"    "+"NO~B1~2"
	
	f1 = addfile("/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/output_CCTM_2020-04-BASE-ISAMnew/CCTM_SA_ACONC_2020-04-BASE_20200416.nc","r")
    f2 = addfile("/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/output_CCTM_2020-04-BASE-ISAM1203/CCTM_SA_ACONC_2020-04-BASE_20200416.nc","r")

    xab = (f1->NO2_BCO(8,:,:,:) - f2->NO2_BCO(8,:,:,:))*1000*46/22.4

printVarSummary(xab)

    fon   = (/"plot"/)
	wks     = gsn_open_wks("png",fon)
;    wks     = gsn_open_wks("png","ab-a-b-SOA")
        clbdft  = "WhiteBlueGreenYellowRed"                      ; Colorbar Default
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
        res@cnInfoLabelOn       = True
        res@cnInfoLabelOrthogonalPosF = -0.04
        res@cnInfoLabelString   = "Max:"+sprintf("%4.1f",max(xab))+"  Min:"+sprintf("%4.1f",min(xab))+"  Mean: "+sprintf("%4.1f",avg(xab))

        res@cnLevelSelectionMode= "ManualLevels"
        res@cnMinLevelValF      = -20
        res@cnMaxLevelValF      = 20
        res@cnLevelSpacingF     = 0.5
		res@mpDataBaseVersion     = "MediumRes"  ; Medium resolution database
		res@tiMainFontHeightF	= 0.028
		res@tiDeltaF		= 1 
        res@gsnRightString      = righttitle
		res@gsnRightStringFontHeightF = 18
    printVarSummary(xab)
    plot1    = gsn_csm_contour_map(wks,xab,res)

;  fshp_c  = "/GFPS8p/xyyang/wk/ncljq/shp/cn_province.shp"
  fshp_sc  = "/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp"
  lnres                  = True
  lnres@gsLineThicknessF =2.0
printVarSummary(fshp_c)
  poly1 = gsn_add_shapefile_polylines(wks,plot1,fshp_c,lnres)

    draw(plot1)
    frame(wks)

    print(" ")

  print("---------------- Done!!! -------------------")
end
