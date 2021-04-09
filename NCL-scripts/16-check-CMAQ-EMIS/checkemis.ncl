load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

    fia  = addfile("/GFPS8p/xyyang/wk/emis/emis_fromLYM/output/EM_M_03_08CHINA_2016092","r")
    fib  = addfile("/GFPS8p/xyyang/wk/emis/emis_fromLYM/output/EM_M_03_08CHINA_2016093","r")
;    fno  = "/GFPS8p/xyyang/wk/emis/emis_fromLYM/output/EM_M_03_08CHINA_2016094"

;    fio  = addfile(fno,"w")
    vars = getfilevarnames(fia)
    nvar = dimsizes(vars)

do v = 0, nvar-1
    do i = 0, 24
    dims := getvardims(fia->$vars(v)$)
    rank = dimsizes(dims)
        if (rank.eq.4) then
            print("working: "+vars(v))
            if (isfilevar(fib,vars(v))) then
                diff = fia->$vars(v)$(i,0,:,:) - fib->$vars(v)$(i,0,:,:)
                printMinMax(diff, False)
            end if
        end if
    end do
end do

end
