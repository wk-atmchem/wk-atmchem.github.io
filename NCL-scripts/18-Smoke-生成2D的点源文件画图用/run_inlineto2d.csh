#!/bin/csh -f

module load netcdf/4.6.1-intel2017

setenv SMOKE_DIR /rsstu/users/f/fgarcia4/garcia_grp/Qian/2015platform
#setenv SMOKE_INLN $SMOKE_DIR/2015fd_cb6_15j/smoke_out/2015fd_cb6_15j/12US1/cmaq_cb6
setenv SMOKE_INLN /rsstu/users/f/fgarcia4/garcia_grp/Qian/smoke_out
setenv INLN $SMOKE_INLN/ptegu_crg/inln_mole_ptegu_20150810_12US1_cmaq_cb6_2015fd_cb6_15j.ncf
setenv STACK_GROUPS $SMOKE_INLN/ptegu_crg/stack_groups_ptegu_12US1_2015fd_cb6_15j.ncf
setenv OUTFILE $SMOKE_INLN/ptegu_crg/2d_0810_crg_new.ncf
setenv LOGFILE $SMOKE_DIR/2015fd_cb6_15j/scripts/lnto2d/log_inlineto2d_crg_new.txt
setenv GRIDDESC $SMOKE_DIR/ge_dat/gridding/griddesc_lambertonly_08dec2017_v0.txt
setenv G_GRIDPATH $SMOKE_DIR/ge_dat/gridding/griddesc_lambertonly_08dec2017_v0.txt
setenv IOAPI_GRIDNAME_1 12US1_459X299
setenv PROMPTFLAG N

./inlineto2d
