;姜琪20190215 兰州 整理后脚本--draw O3和SOA 从原数据画图
;bio表示a和b；nobio表示只有a，onlybio表示只有b
;调tt设置月份
;调vv设置变量
;其他：设置色标 输出文件名
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


ts = 3   ;起始时间   ncdump查看每天小时数 然后计算自己画图时间段起始序号
te = 10   ;结束时间


  months	= (/"07","07"/) ;月份通过循环mm控制
  types        = (/"bio/","nobio/","onlybio/"/)   ;类型case通过循环tt控制
  var          = (/"O3","SOA"/);变量通过循环xx控制

  dir   = "/GFPS8p/xyyang/wk/CMAQ-5.3.1/data/output_CCTM_2017-07-BASE_cn3kmSCAESnobio529/"
;地理信息
  fmapname      = "/GFPS8p/xyyang/wk/CMAQ-5.2.1/data/mcip/2017-01-BASE-sichuan/GRIDCRO2D_2017001.nc"
  fmap    = addfile(fmapname,"r")
do mm = 1, 1
do tt = 0, 0  ;;;不用调
do vv = 0, 0

  units		= (/"~F33~m"+"~F25~g/m~S1~3","micrograms/m~S1~3"/)
  righttitle    = units(vv)+"    "+"O~B1~3"
; lefttitle     = var(vv)
;fab表示a和b;fa表示a;fb表示b路径
;计算数据 xab，xa，xb
   time = "-BASE_20170710*"
	fab = systemfunc("ls " + dir + "CCTM_IRR_1_2017-" + months(mm) + time)
    print(fab(0))  
    day1 = dimsizes(fab)
    data_a = new((/day1,te-ts+1,1,182,232/),"float")
    data_b = new((/day1,te-ts+1,1,182,232/),"float")
    data_ab = new((/day1,te-ts+1,1,182,232/),"float")
      
    if (vv .eq. 0) then
    	do dd = 0, day1 - 1
			ffab = addfile(fab(dd), "r")
            data_a(dd,:,:,:,:) = ffab->NETP_H2O2(ts:te,0,:,:) 
            data_b(dd,:,:,:,:) = ffab->NETP_HNO3(ts:te,0,:,:) 
			data_ab(dd,:,:,:,:) = data_a / data_b
		end do
		xab = dim_avg_n(dim_max_n(data_ab, (/1,2/)), 0)

	end if


printVarSummary(xab)
;计算

        tmpab     = ndtooned(xab)
        abmean   = dim_avg(tmpab)
      

;;;;画图
    fon   = months(mm)
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
                res@cnInfoLabelString   = "Max:"+max(xab)+"   Min:"+min(xab)+"  Mean: "+avg(xab)

                res@cnLevelSelectionMode= "ManualLevels"
                res@cnMinLevelValF      = 0
                res@cnMaxLevelValF      = 1.05
                res@cnLevelSpacingF     = 0.175
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
		res@gsnRightStringFontHeightF = 18
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


  end do
  end do
  end do
  print("---------------- Done!!! -------------------")
end
