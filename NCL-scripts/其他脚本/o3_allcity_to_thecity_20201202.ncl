load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


;;;;以成都为例 "_CD"         HL    "HUALIU"   "OTH"  YA
    city  = (/"BCO","ICO","OTH","BZ","CD","CQ","DY","DZ","GA","GY","LS","LZ","MS","MY","NC","NJ","SN","YA","YB","ZG","ZY"/)
nn_vars = dimsizes(city)  ;;;;变量个数
print(nn_vars)
    city_shp    = (/"CD","CQ","DY","HUALIU","LS","LZ","MY","NC","NJ","YA","RS","SN","YB","ZG","ZY"/)
nn_ct = dimsizes(city_shp)  ;;;;城市数
print(nn_ct)
    dir_data   = "/GFPS8p/xyyang/wk/CMAQ-5.3.2/data/output_CCTM_2020-04-BASE-ISAMnew/"
    f_names = systemfunc("ls " + dir_data  + "CCTM_SA_ACONC_2020-04-BASE_2020*") 
    day = dimsizes(f_names) 
    print(day)
    nn_t = 24*day  ;;;;;时间长度

    f_name = addfiles(f_names, "r")
    data_vars = new((/nn_vars,nn_t,1,182,232/),"float", -999)  ;;;;不同城市的贡献

    do i = 0, nn_vars - 1
      vars_ct = "O3_" +  city(i)
      print(vars_ct)
      data_vars(i,:,:,:,:) = 1000*48/22.4*f_name[:]->$vars_ct$  
    end do     
    printVarSummary(data_vars)

;;;;读取城市shp文件,mask数据
  dir_shp   =        "/GFPS8p/xyyang/wk/CMAQ-5.2.1/SA/Spatial-Allocator-master/scripts/output/oldSCB/"   ;;;

;  data_vars14 = new((/15,1,1,182,232/),"float")
;  do i = 0, nn_ct
  do i = 0, 0

;;;;;;    f_shp = addfile(dir_shp + "SCB_" + city_shp(i) + ".ncf", "r")
    

    f_shp = addfile("/GFPS8p/xyyang/wk/121wktest/SCBfinal.nc", "r")


    vars_shp = city_shp(i) + "_1"
    data_shp = f_shp->$vars_shp$  

    data_vars_mask = new((/nn_vars,nn_t,1,182,232/),"float", -999)
      do ct = 0, nn_vars - 1
        do t = 0, nn_t-1
          data_vars_mask(ct,t,0,:,:) = where(data_shp(0,0,:,:) .eq. 1, data_vars(ct,t,0,:,:), data_vars@_FillValue)
        end do
      end do

  data_vars_avg = dim_avg_n_Wrap(data_vars_mask, (/2,3,4/))

printVarSummary(data_vars_avg)
;;;;;输出
  csv_filename = "2020-04-BASE_202004_all_to" + city_shp(i) + ".csv"
  header = [/str_join((/"BCO","ICO","OTH","BZ","CD","CQ","DY","DZ","GA","GY","LS","LZ","MS","MY","NC","NJ","SN","YA","YB","ZG","ZY"/),",")/]

;  csv_filename = ""zhandian" + .csv"
  system("rm -rf " + csv_filename)
  write_table(csv_filename, "w", header, "%s")

  format = "%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g"

    alist  = [/data_vars_avg(0,:),data_vars_avg(1,:),data_vars_avg(2,:),data_vars_avg(3,:),data_vars_avg(4,:),data_vars_avg(5,:),data_vars_avg(6,:),data_vars_avg(7,:),data_vars_avg(8,:),data_vars_avg(9,:),data_vars_avg(10,:),data_vars_avg(11,:),data_vars_avg(12,:),data_vars_avg(13,:),data_vars_avg(14,:),data_vars_avg(15,:),data_vars_avg(16,:),data_vars_avg(17,:),data_vars_avg(18,:),data_vars_avg(19,:),data_vars_avg(20,:)/]
    write_table(csv_filename, "a", alist, format)

  delete([/f_shp,vars_shp,data_shp,data_vars_mask,data_vars_avg,csv_filename/])

  end do


end
