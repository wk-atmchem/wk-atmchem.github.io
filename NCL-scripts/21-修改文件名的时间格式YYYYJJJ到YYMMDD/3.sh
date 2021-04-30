#!/bin/sh
for files in `ls GRIDDOT2D_*.nc`
do
echo $files
export ORI=${files:0:10}
export YYYY=${files:0-10:4}
export dd=$YYYY'-01-01'
dds=$(date -d $dd +%s)
# echo $dds
export Ndate=${files:0-6:3}
ddplus=$(expr $Ndate \* 24 \* 60 \* 60)
# echo $(($Ndate*2))
# echo $ddplus
yys=$(($dds+$ddplus-86400))
# echo $yys
YYMMDD=$(date -d @$yys +%y%m%d)
# echo $YYMMDD
#echo $ORI$YYMMDD
ln -sf $files $ORI$YYMMDD
done 
