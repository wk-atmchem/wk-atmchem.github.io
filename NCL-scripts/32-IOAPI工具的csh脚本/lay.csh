#!/bin/csh -f
# layalloc used
set DATENOW1JUL=`date -d '-1 days' +%Y%j`
./layalloc << eof
y
METCRO3D.nc
lay
emission.nc
emission_${DATENOW1JUL}.nc
eof

