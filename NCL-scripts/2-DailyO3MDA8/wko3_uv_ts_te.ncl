;姜琪 20200526 武汉 整理脚本--draw O3模拟结果  风场 
;模拟结果数据O3  CCTM_ACONC_*
;模拟结果数据O3  METCRO2D_*
;
;先设置属性（观测属性在观测模块设置） 画模拟结果  添加shp  然后风场
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;预留    mm   vv 暂不使用
;调mm设置月份                          
;调vv设置变量
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


draw_o3 = True   ;;;;;True画图 False不画
draw_uv = True   ;;;;;True画图 False不画
draw_obs = True  ;;;;;True画图 False不画

  year =   "2017" 
  months	= "07"     ;月份
  var          = "O3"  ;变量

  dir_O3   = "/GFPS8p/xyyang/wk/CMAQ-5.3.1/data/output_CCTM_"+year+"-"+months+"-BASE_cn3kmSCAES/"
  dir_uv   = "/GFPS8p/xyyang/wk/ncljq/20200527_o3_uv/"

ts = 3   ;起始时间   0-23
te = 10   ;结束时间   0-23世界时

MaxF          = 200  ;;色标
MinF          = 0
SpaceF        = 5  ;间隔


lon1 = 45   ;;;修改画图左下角和右上角格点数  1左下  2右上   0-231
lon2 = 211  ;;;  lon1-231
lat1 = 30   ;;;  0-181
lat2 = 171  ;;;  lat1-181


;地理信息
    fmapname      = "/GFPS8p/xyyang/wk/ncljq/20200322/GRIDCRO2D_2016229.nc"
    fmap    = addfile(fmapname,"r")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;设置画图属性
;
	wks=gsn_open_wks("png","O3_obs_uv")
	clbdft  = "WhiteBlueGreenYellowRed";颜色利用NCL调色板生成，具体可在论坛搜索“调色板”
	gsn_define_colormap(wks,clbdft)

    res=True
    res@gsnMaximize=True
    res@gsnFrame=False
    res@gsnDraw=False

    res@gsnSpreadColors=True
    res@cnFillOn=True
    res@cnLinesOn=False
    res@cnLineLabelsOn=False
    res@cnLevelSelectionMode="ExplicitLevels"
    

;;;mis和obs用同一个色标
    levels = fspan(MinF, MaxF, (MaxF-MinF)/SpaceF+1)
    nlevels = dimsizes(levels)
    colors  = span_color_rgba(clbdft,nlevels+1)
;    printVarSummary(colors)
    res@cnLevels=levels

;---坐标轴属性---------------------
    res@pmTickMarkDisplayMode="Always"   ;添加°
    res@pmLabelBarDisplayMode="Always"
    res@tmXTOn=False
    res@tmYROn=False
;   res@tmXBLabelStride=2
    res@tmBorderThicknessF=4
;-----------------------------------
;-------地图属性---------------
    res@mpGeophysicalLineColor = "Black"
    res@mpGeophysicalLineThicknessF=3.
    res@mpNationalLineThicknessF=3.
    res@mpUSStateLineThicknessF=3.
    res@mpNationalLineColor    = "Black"
    res@mpUSStateLineColor     = "Black"
    res@mpGridLineColor        = "Black"
    res@mpLimbLineColor        = "Black"
    res@mpPerimLineColor       = "Black"
    res@mpProjection="LambertConformal"
    res@mpLambertMeridianF=110.0
    res@mpLambertParallel1F=25.
    res@mpLambertParallel2F=40.
    res@mpLimitMode="Corners"

    res@mpLeftCornerLatF    = fmap->LAT(0,0,lat1,lon1)
    res@mpLeftCornerLonF    = fmap->LON(0,0,lat1,lon1)
    res@mpRightCornerLatF   = fmap->LAT(0,0,lat2,lon2)
    res@mpRightCornerLonF   = fmap->LON(0,0,lat2,lon2)

    res@mpDataBaseVersion="MediumRes"
    res@mpDataSetName         = "/GFPS8p/xyyang/wk/ncl/NCL-Chinamap-master/database/Earth..4"
    res@mpOutlineBoundarySets = "NoBoundaries"  ;;;不显示自带边界

    res@lbOrientation         = "Vertical"  
    res@tfDoNDCOverlay = True

;-------风属性---------------
    windRes = True
;    windRes = res
    windRes@gsnDraw  = False
    windRes@gsnFrame = False
    windRes@tfDoNDCOverlay       = True
    windRes@gsnLeftString  = ""
    windRes@gsnRightString = ""
    windRes@vcRefAnnoOn  = True  ;;打开矢量箭头
    windRes@vcRefAnnoSide = "Top" ;参考位置
;    windRes@vcRefAnnoOrthogonalPosF = -0.07 ;相对于参考位置的垂直位置移动
    windRes@vcRefAnnoExplicitMagnitudeF = 3.0 ;箭头长短代表的大小
    windRes@vcGlyphStyle = "LineArrow"   ;;;线条类型
    windRes@vcLineArrowThicknessF = 5.  ;箭头大小
;    windRes@vcRefMagnitudeF = 3
    windRes@vcRefAnnoString2 = "3 m/s"
    windRes@vcRefAnnoPerimOn = False
    windRes@vcRefAnnoString1On = False
    windRes@vcRefAnnoString2On = True
    windRes@vcMinDistanceF        = 0.02  ;;;箭头密度,画图疏密
    windRes@vcRefLengthF          = 0.08  ;;设置标尺大小  
    windRes@vcMonoLineArrowColor  =True    
    windRes@vcLineArrowColor      = "blue"  ;;设置线条颜色


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;读取数据
;O3模拟结果
	f_o3 = systemfunc("ls " + dir_O3 + "CCTM_ACONC_"+ year +"-" + months + "-BASE_"+year+months+"*")
    print(f_o3(0))  
    f_uv = systemfunc("ls " + dir_uv +"METCRO2D_"+ year +"*.nc")
    print(f_uv(0))
    day_o3 = dimsizes(f_o3)
    day_uv = dimsizes(f_uv)
    if (day_uv .ne. day_o3 ) then
        ; write branch
    end if

    data_o3 = new((/day_o3,te-ts+1,1,182,232/),"float")
    WSPD10 = new((/day_o3,te-ts+1,1,182,232/),"float")
    WDIR10 = new((/day_o3,te-ts+1,1,182,232/),"float")


    time_dd = new(day_o3,"float")
    do dd = 0, day_o3 - 1
		ff_o3 = addfile(f_o3(dd), "r")
        ff_uv = addfile(f_uv(dd), "r")
        if (dd .eq. 0) then
            time_o3_1 = ff_o3->TFLAG(0,0,0)
            time_yyyymmdd_1 = yyyyddd_to_yyyymmdd(time_o3_1)
            print(time_yyyymmdd_1)
            time_uv_1 = ff_uv->TFLAG(0,0,0)
;            print(time_o3_1)
;            print(time_uv_1)
            if (time_uv_1 .ne. time_o3_1) then
                print("Time mismatch")
                exit
            end if
        end if

        time_dd(dd) =  mod(yyyyddd_to_yyyymmdd(ff_o3->TFLAG(0,0,0)), 100)
        ;print(time_dd(dd))
		
        data_o3(dd,:,:,:,:) = ff_o3->$var$(ts:te,:,:,:)* 1000 * 48 / 22.4
        WSPD10(dd,:,:,:,:) =   ff_uv->WSPD10(ts:te,:,:,:)
        WDIR10(dd,:,:,:,:) =   ff_uv->WDIR10(ts:te,:,:,:)
	end do
	data_o3_avg = dim_avg_n_Wrap(data_o3(:,:,:,:,:), (/1,2/)) 

    o3_mean  =dim_avg_n_Wrap(data_o3_avg, (/1,2/))
    o3_max = dim_max_n_Wrap(data_o3_avg, (/1,2/))
    o3_min = dim_min_n_Wrap(data_o3_avg, (/1,2/))

    u = WSPD10*cos(WDIR10 *3.1415926 /180.0)
    v = WSPD10*sin(WDIR10 *3.1415926 /180.0)
    u_avg = dim_avg_n_Wrap(u(:,:,:,:,:), (/1,2/)) 
    v_avg = dim_avg_n_Wrap(v(:,:,:,:,:), (/1,2/)) 
    
    plot = new(day_o3,graphic)                ; create graphic array
    windPlot = new(day_o3,graphic)                ; create graphic array  
    do i = 0, day_o3-1

        res@gsnLeftString= "O~B~3~N~" +" at "+ year + "-"+ months+ "-" + time_dd(i)
        if (i .le. 10) then
           res@gsnLeftString= "O~B~3~N~" +" at "+  year + "-"+ months+ "-0" + time_dd(i)
        end if
        res@gsnRightString= "~F33~m~F~g/m~S~3~N~"
        res@cnInfoLabelOn       = True
        res@cnInfoLabelOrthogonalPosF = -0.04
        res@cnInfoLabelString   = "Max: $ZMX$   Min: $ZMN$   Mean: "+ sprintf("%4.1f",o3_mean(i))
        plot(i)    = gsn_csm_contour_map(wks,data_o3_avg(i,:,:),res)
        ; windPlot(i)  = gsn_csm_vector(wks, u_avg(:,:), v_avg(:,:), windRes)
        windPlot(i)  = gsn_csm_vector(wks, u_avg(i,:,:), v_avg(i,:,:), windRes)
        overlay(plot(i), windPlot(i))  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;添加shp
        fshp_sc  = "/GFPS8p/xyyang/wk/ncljq/shp/scbasin.shp"
        lnres                  = True
        lnres@gsLineThicknessF =2.0
        ;printVarSummary(fshp_sc)
        poly1 = gsn_add_shapefile_polylines(wks,plot(i),fshp_sc,lnres)

    draw(plot(i))
    frame(wks)
    end do

end