begin

	year	= 2018
	stday	= 20180111      ;   87,177,269
	enday	= 20180131     ;    120, 212, 304
	month   = "09"
	case    = "BASE"

do d = stday,enday
	fna	= "/dfs5/apep/wuk15/BCON4CMAQ/append_test/new"+d+".ncf"
	fno	= "/dfs5/apep/wuk15/BCON4CMAQ/append_test/bc.new."+d+".ncf"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT = fia->TFLAG

; TT是一个25*46*2的字符串矩阵
; 25的意思是有25个时间节点，在此表示每隔1小时一次,在序号上来看，0-23是2019330，24号是2019331
; 46是此文件中共有46个变量
; 其中最后一个维度中的0序号代表日期，格式为YYYYDDD，1序号代表时间HHMMSS

	TT(0,:,1)=80000
        TT(1,:,1)=140000
        TT(2,:,1)=200000
        TT(3,:,1)=20000

	fw = addfile(fno,"w")
	fw->TFLAG = TT
;	fw@SDATE  = julday_anemis
;	fw@CDATE  = 2017364
;	fw@WDATE  = 2017364
        fw@STIME  = 80000
;        fw@STIME  = 0
end do
end
