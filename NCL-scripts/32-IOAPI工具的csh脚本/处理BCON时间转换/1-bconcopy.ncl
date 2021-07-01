begin

	stday	=  20180101      ;   87,177,269
	enday	=  20180131     ;    120, 212, 304

    do d = stday,enday

    fna = "/dfs5/apep/wuk15/BCON4CMAQ/mozart2camx_v3.2.2/jobs/output/bc.4km.cmaq.SAPRC."+d+".lst.ncf" ;bc.4km.cmaq.SAPRC.20180601.lst.ncf
    fnb = "/dfs5/apep/wuk15/BCON4CMAQ/append_test/"+d+".nc"

    system("cp "+fna+" "+fnb)

    end do

end
