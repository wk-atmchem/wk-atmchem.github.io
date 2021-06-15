;Written by Kai Wu, UC Irvine, September, 2020
; contact wukaicuit@gmail.com
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
wks=gsn_open_wks("png","pm25-obs-vector-hourly")
gsn_define_colormap(wks,"8colors") ;颜色利用NCL调色板生成，具体可在论坛搜索“调色板”
plot=new(9,graphic)
         res=True
         res@gsnMaximize=True
         res@gsnFrame=False
         res@gsnDraw=False
         res@gsnSpreadColors=True
         res@cnFillOn=True
         res@cnLinesOn=False
         res@cnLineLabelsOn=False
         res@cnLevelSelectionMode="ExplicitLevels"
         res@cnLevels=(/35,75,115,150,250,350,500/)
         res@lbLabelBarOn=False
         ;---坐标轴属性---------------------
         res@pmTickMarkDisplayMode="Always"
         res@pmLabelBarDisplayMode="Always"
         res@tmXTOn=False
         res@tmYROn=False
         res@tmXBLabelStride=2
         res@tmXBLabelFont=25
         res@tmXBLabelFontHeightF=0.01
         res@tmYLLabelFont=25
         res@tmYLLabelFontHeightF=0.01
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
         res@mpLambertMeridianF=117.0
         res@mpLambertParallel1F=30.
         res@mpLambertParallel2F=60.
         a=addfile("geo_em.d01.nc","r")
         lat=a->CLAT
         lon=a->CLONG
         res@mpLimitMode="Corners"
         res@mpLeftCornerLatF = lat(0,0,0)
         res@mpRightCornerLatF = lat(0,199,199)
         res@mpLeftCornerLonF = lon(0,0,0)
         res@mpRightCornerLonF = lon(0,199,199)
         res@mpDataBaseVersion="MediumRes"
         res@mpDataSetName="Earth..4"
         
         res@mpOutlineSpecifiers=(/"China","BeijingShi","Hebei","Tianjinshi","Henan","Shanxi","Shandong",  \
                   "Heilongjiang","Jilin","Liaoning","Nei Mongol", \
                   "Fujian","Guandong","Guangxi","Hong Kong","Hainan", \
                  "Jiangxi","Hubei","Hunan","Jiangsu","Zhejiang","Shanghai Shi","Anhui", \
                   "Shaanxi","Qinghai","Xizang","Xinjiang Uygur","Ningxia Huizu","Gansu", \
                   "Yunnan","Sichuan","Guizhou","Chongqing Shi"/)
         res@tfDoNDCOverlay = True
         
         ;=======读入数据===============================
         d=addfile("wrfout_d01_2015-10-13_12:00:00","r")
         ps=wrf_user_getvar(d,"p",-1)
         tp=wrf_user_getvar(d,"tk",-1)
         u10=wrf_user_getvar(d,"U10",-1)
         v10=wrf_user_getvar(d,"V10",-1)
         u10_avg=dim_avg_n_Wrap(u10,0)
         v10_avg=dim_avg_n_Wrap(v10,0)
         PM25= d->P25AJ(:,0,:,:)
         PM25=PM25*ps(:,0,:,:)*29.0*0.001/(8.314*tp(:,0,:,:)) ;数据单位转换
         
         PM25_avg_1=runave(dim_avg_n_Wrap(PM25,0),5,0) ;曲线平滑处理
         plot(0)=gsn_csm_contour_map(wks,PM25_avg_1,res)

        ;-----添加风场----------------------
         vres=True
         vres@gsnDraw=False
         vres@gsnFrame=False
         vres@vcRefMagnitudeF=4.
         vres@vcRefLengthF=0.03
         vres@vcRefAnnoOn=False
         ;vres@vcRefAnnoString1On=False;"~F25~4m/s"
         ;vres@vcRefAnnoString2On=False
         ;vres@vcRefAnnoFontHeightF=0.015
         ;vres@vcRefAnnoPerimOn=False ;do not display box line
         vres@vcGlyphStyle="LineArrow" ;"CurlyVector";
         plot_v1=gsn_vector(wks,u10_avg,v10_avg,vres)
         ;--------------添加标记点---------------------------------
C=(/"Beijing","Tianjin","Shijiazhuang","Tangshan","Zhangjiakou","Langfang", \
    "Baoding","Xingtai","Baotou","Zibo","Yantai","Weifang",\
    "Dongying","Kaifeng","Luoyang","Zhengzhou","Handan",\
    "Liaocheng","Dezhou","Laiwu","Xi'an",\
    "Chengde","Cangzhou","Hengshui",\
    "Ji'nan","Tai'an","Weifang","Binzhou","Qingdao","Jining","Heze",\
    "Linyi","Zaozhuang","Weihai","Nanyang","Xuchang","Sanmenxia",\
    "Pingdingshan","Zhoukou","Zhumadian","Xinxiang","Hebi","Jiaozuo",\
    "Puyang","Anyang","Shangqiu","Xinyang"/)
numcity=dimsizes(C)
B=asciiread("obs_polymarkers.txt",numcity,"float") ;该文件为各点位的观测值

lat_city=(/39.91,39.13,38.02,39.36,40.48,39.31,\
           38.51,37.04,40.39,36.48,37.32,36.43,\
           37.27,34.47,34.41,34.46,36.36,36.26,\
           37.26,36.12,34.27,40.59,38.18,\
           37.44,36.40,36.11,36.43,37.22,36.03,\
           35.23,35.14,35.03,34.52,37.31,33.00,\
           34.01,34.47,33.44,33.37,32.58,35.18,\
           35.54,35.14,35.44,36.06,34.26,32.07/)

lon_city=(/116.41,117.2,114.3,118.11,114.53,116.42,\
           115.30,114.30,109.49,118.03,121.24,119.06,\
           118.30,114.21,112.27,113.40,114.28,115.57,\
           116.17,117.40,108.95,117.57,116.52,\
           115.42,117.00,117.08,119.06,118.02,120.18,\
           116.33,115.26,118.20,117.33,122.07,112.32,\
           113.49,111.12,113.17,114.38,114.01,113.52,\
           114.11,113.12,115.01,114.21,115.38,114.04/)

          obs=new(numcity,"float")
          site_x=new(numcity,"float")
          site_y=new(numcity,"float")

         do i=0,numcity-1
              obs(i) = B(i)
              site_x(i) = lon_city(i)
              site_y(i) = lat_city(i)
        end do

        obs@_FillValue=9.96921e+36
        obs=where(obs .le. 0.0,obs@_FillValue,obs)

         cmap_name = "8colors";"WhiteBlueGreenYellowRed"
         cmap=read_colormap_file(cmap_name)

         levels=res@cnLevels

         ;----------标记点边界属性--------------（可选）
         gres=True
         gres@gsMarkerIndex = 1
         gres@gsMarkerSizeF = 16
         ;gres@gsMarkerColor = "red"
         gres@gsMarkerThicknessF = 4.0

         ;----------标记点属性--------------         
         ores=True
         ores@gsMarkerIndex = 4
         ores@gsMarkerSizeF = 8
         ores@gsMarkerColor = "black"
         ores@gsMarkerThicknessF = 0.8
         
         dum_1 = new(N2,graphic)
         dum_d_1 = new(N2,graphic)
         j=0
         do i=0,N2-1
           if (ismissing(obs_plot(i))) then
              continue
           else
            color_index = get_color_rgba(cmap_name,levels,obs(i))
            gres@gsMarkerColor = color_index
            dum_1(i)=gsn_add_polymarker(wks,plot(0),site_x(i),site_y(i),gres)
            dum_d_1(i)=gsn_add_polymarker(wks,plot(0),site_x(i),site_y(i),ores)
           end if
             j=j+1
            end do
         overlay(plot(0),plot_v1)
         delete([/b,c,d,ps,tp,PM25/])
         ;===============================================
         ;plot共9个，上面是plot（0）的，plot（1）至plot（8）与上面基本一致
         ;就不在重复
         ;===============================================
         ;=========多图绘制============================
         res@gsnCenterString=""
         res@gsnRightString=""
         res@gsnLeftString=""
         pnlres=True
         ;pnlres@gsnPanelYWhiteSpacePercent=3
         ;pnlres@gsnPanelXWhiteSpacePercent=3
         ;pnlres@gsnPanelScalePlotIndex=1
         pnlres@gsnPanelFigureStrings=(/"~F25~a)10-13 20:00 BJT",\
                                                  "~F25~b)10-14 08:00 BJT","~F25~c)10-14 20:00 BJT",\
                                                   "~F25~d)10-15 08:00 BJT","~F25~e)10-15 20:00 BJT",\
                                                   "~F25~f)10-16 08:00 BJT","~F25~g)10-16 20:00 BJT",\
                                                   "~F25~h)10-17 08:00 BJT","~F25~i)10-17 20:00 BJT"/)
         pnlres@gsnPanelFigureStringsFontHeightF=0.01
         pnlres@amJust="topLeft"
         ;pnlres@gsnPanelFigureStringsBackgroundFillColor=0
         pnlres@lbLabelBarOn=True
         pnlres@gsnMaximize=True
         pnlres@gsnPanelLabelBar=True
         
         ;---------统一色标---------------------
         pnlres@lbLabelFont=25
         pnlres@lbTopMarginF=0.05
         pnlres@lbLabelFontHeightF=0.0105
         gsn_panel(wks,plot,(/3,3/),pnlres)  ; 多图排列，三行三列
end
