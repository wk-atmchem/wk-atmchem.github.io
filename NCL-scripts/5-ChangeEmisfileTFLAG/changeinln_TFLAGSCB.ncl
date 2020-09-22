begin

	year	= 2017
	stday	= 209      ;   87,177,269
	enday	= 243     ;    120, 212, 304
	month   = "09"
	case    = "BASE"

do d = stday,enday

	julday	= year * 1000 + d       ;2017000+177=2017177
    julday_anemis = julday + 2000   ;2017177-1000=2016177
	
	fna	= "/GFPS8p/xyyang/wk/319wktest/inlnts_l.point."+julday+".1.3km.base2017.ncf"  ;inlnts_l.point.2017191.1.3km.base2017.ncf
	fno	= "/GFPS8p/xyyang/wk/428wktest/anth/inlnts_l.point."+julday_anemis+".1.3km.base2019.ncf"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT = fia->TFLAG

; TT是一个25*46*2的字符串矩阵
; 25的意思是有25个时间节点，在此表示每隔1小时一次,在序号上来看，0-23是2019330，24号是2019331
; 46是此文件中共有46个变量
; 其中最后一个维度中的0序号代表日期，格式为YYYYDDD，1序号代表时间HHMMSS

	do mm = 0,23
		TT(mm,:,0)=julday_anemis
	end do
		TT(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2017364
	fw@WDATE  = 2017364

end do
end
