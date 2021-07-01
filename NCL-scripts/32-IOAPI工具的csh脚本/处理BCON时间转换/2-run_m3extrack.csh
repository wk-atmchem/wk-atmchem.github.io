#!/bin/csh -f

set SDATE = 20180101
set EDATE = 20180131

while ($SDATE <= $EDATE)
echo $SDATE
set julday = `/dfs5/apep/wuk15/CMAQlib/ioapi-3.2/bin/greg2jul $SDATE`

./m3xtract << eof
$SDATE.nc
0
-1
$julday
060000
180000
new$SDATE.ncf
eof


@ SDATE ++

end
