begin

	julday	= 2016353       ;2017000+177=2017177
    julday_anemis = julday   ;2017177-1000=2016177
	
;GRIDBDY2D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDBDY2D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDBDY2D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")

	fw = addfile(fno,"w")
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160

;GRIDCRO2D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDCRO2D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDCRO2D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")

	fw = addfile(fno,"w")
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;GRIDDOT2D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDDOT2D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/GRIDDOT2D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")

	fw = addfile(fno,"w")
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;LUFRAC_CRO.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/LUFRAC_CRO_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/LUFRAC_CRO_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")

	fw = addfile(fno,"w")
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;METBDY3D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METBDY3D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METBDY3D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT5 = fia->TFLAG

	do mm = 0,23
		TT5(mm,:,0)=julday_anemis
	end do
		TT5(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT5
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;METCRO2D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METCRO2D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METCRO2D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT6 = fia->TFLAG

	do mm = 0,23
		TT6(mm,:,0)=julday_anemis
	end do
		TT6(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT6
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;METCRO3D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METCRO3D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METCRO3D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT7 = fia->TFLAG

	do mm = 0,23
		TT7(mm,:,0)=julday_anemis
	end do
		TT7(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT7
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;METDOT3D.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METDOT3D_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/METDOT3D_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT8 = fia->TFLAG

	do mm = 0,23
		TT8(mm,:,0)=julday_anemis
	end do
		TT8(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT8
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


;SOI_CRO.nc
	fna	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/SOI_CRO_2016352.nc"  
	fno	= "/dfs5/apep/wuk15/CMAQ-5.3.2/data/mcip/2016-CA/SOI_CRO_2016353.nc"   
	system("rm "+fno)
	system("cp "+fna+" "+fno)
	
	fia = addfile(fna,"r")
	TT9 = fia->TFLAG

	do mm = 0,23
		TT9(mm,:,0)=julday_anemis
	end do
		TT9(24,:,0)=julday_anemis + 1

	fw = addfile(fno,"w")
	fw->TFLAG = TT9
	fw@SDATE  = julday_anemis
	fw@CDATE  = 2021160
	fw@WDATE  = 2021160


end
