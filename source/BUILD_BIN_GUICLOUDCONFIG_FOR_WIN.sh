echo "usage: ./BUILD_BIN_GUICLOUDCONFIG_FOR_WIN.sh 32|64"
bb=$1
if [ ${bb:=0 } -eq 0   ]
    then 
	echo "Bad type 32|64"
	exit 1
fi
if [ $1 -ne 64  -a $1 -ne 32 ]
    then 
	echo "Bad type 32|64"
	exit 1
fi
a=WIN32_WRAP664
cp -f ls11cloud_32.dll ls11cloud.dll
cp -f lprng_init_auto_32.exe  lprng_init_auto.exe
cp -f ls11cloud_config_32.exe ls11cloud_config.exe
cp -f p11conf_32.exe          p11conf.exe

if [ "$1" -eq "64 " ]
    then 
	a=WIN64_WRAP664
	cp -f ls11cloud_64.dll  ls11cloud.dll
	cp -f lprng_init_auto_64.exe  lprng_init_auto.exe
	cp -f ls11cloud_config_64.exe ls11cloud_config.exe
	cp -f p11conf_64.exe          p11conf.exe
fi
echo $a

iconv -f UTF-8 -t CP1251 guils11cloud_conf.tcl > guils11cloud_conf_CP1251.tcl

../../freewrap guils11cloud_conf_CP1251.tcl `cat LIST_UTIL_WIN32_64.txt` logo_cloud.png -i cloud.ico -w ../../$a/freewrap.exe -o guils11cloud_conf_win$1.exe
#/usr/local/bin64/freewrap GUITKP11Conf_COMBO_CP1251.tcl -w $1/freewrap.exe -i smart_32x32.ico
chmod 755 guils11cloud_conf_win$1.exe
rm -f guils11cloud_conf_CP1251.tcl
rm -f ls11cloud.dll
rm -f lprng_init_auto.exe
rm -f ls11cloud_config.exe
rm -f p11conf.exe



