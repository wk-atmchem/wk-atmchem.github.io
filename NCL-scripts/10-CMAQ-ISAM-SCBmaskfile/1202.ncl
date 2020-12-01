begin

	fna	= "/GFPS8p/xyyang/wk/121wktest/SCBcjy.nc"
    fnb = "/GFPS8p/xyyang/wk/121wktest/SCBold.nc" 
	fno	= "/GFPS8p/xyyang/wk/121wktest/SCBfinal.nc"   
	system("rm "+fno)
	system("cp "+fnb+" "+fno)

    fia = addfile(fna,"r")
	fib = addfile(fnb,"r")
     CD = fia->CD
 	 CQ = fia->CQ
     ZG = fia->ZG
     LZ = fia->LZ
     DY = fia->DY
     MY = fia->MY
     GY = fia->GY
     SN = fia->SN
     NJ = fia->NJ
     LS = fia->LS
     NC = fia->NC
     MS = fia->MS
     YB = fia->YB
     GA = fia->GA
     DZ = fia->DZ
     YA = fia->YA
     BZ = fia->BZ
     ZY = fia->ZY

    fw = addfile(fno,"w")
    fw->CD_ =CD              
    fw->CQ_ =CQ
    fw->ZG_ =ZG
    fw->LZ_ =LZ
    fw->DY_ =DY
    fw->MY_ =MY
    fw->GY_ =GY
    fw->SN_ =SN
    fw->NJ_ =NJ
    fw->LS_ =LS
    fw->NC_ =NC
    fw->MS_ =MS
    fw->YB_ =YB
    fw->GA_ =GA
    fw->DZ_ =DZ
    fw->YA_ =YA
    fw->BZ_ =BZ
    fw->ZY_ =ZY              

end