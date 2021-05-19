begin

	year	= 2016
	stday	= 32      ;   87,177,269
	enday	= 218     ;    120, 212, 304
	month   = "09"
	case    = "BASE"

do d = stday,enday

	julday	= year * 1000 + d       ;2017000+177=2017177
    julday_anemis = julday          ;2017177-1000=2016177
	
	fna	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.M_04_08CA.SAPRC07."+julday+".nc"  
	fno	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.CA.SAPRC07."+julday_anemis+".nc"   
	system("rm "+fno)
	system("ncrcat -v GDAY -x "+fna+" "+fno)
end do

do d = stday,enday

	julday	= year * 1000 + d       ;2017000+177=2017177
    julday_anemis = julday          ;2017177-1000=2016177

    fnb	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.CA.SAPRC07."+julday_anemis+".nc"  
	fnc	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.CA."+julday_anemis+".nc"
;	varlist = str_get_dq()+"ISOP            TERP            OLE2            ARO2            ALK5            XC              OLE1            MEOH            ACET            CH4             NH3             NO              CCHO            ALK3            FACD            HCHO            AACD            BALD            MEK             RCHO            ALK4            ARO1            BACL            CO              ALK1            ETHE            ALK2            APIN            "+str_get_dq()
	varlist = str_get_dq()+"ISOP            TERP            OLE2            ARO2            ALK5            XC              OLE1            MEOH            ACET            CH4             NH3             NO              CCHO            ALK3            FACD            HCHO            AACD            BALD            MEK             RCHO            ALK4            ARO1            BACL            CO              ALK1            ETHE            ALK2            APIN            "+str_get_dq()
	print(varlist)
	system("ncatted -O -h -a VAR-LIST,global,m,c,"+varlist+" " +fnb+" "+fnc)
end do


do d = stday,enday

	julday	= year * 1000 + d       ;2017000+177=2017177
    julday_anemis = julday          ;2017177-1000=2016177
	
	fnd	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.CA."+julday+".nc"
	fne	= "/dfs5/apep/wuk15/MEGANv2.10/2016-30layer/MEGANv2.10.new."+julday_anemis+".nc"   
	system("rm "+fne)
	system("cp "+fnd+" "+fne)
	
	fia = addfile(fnd,"r")
	fw = addfile(fne,"w")

	fw@NVARS  = 28


end do



end
