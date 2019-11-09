echo "usage: ./BUILD_BIN_GUICLOUDCONFIG_FOR_LINUX.sh 32|64"
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
a=LINUX32_WRAP664
cp -f libls11cloud_32.so  libls11cloud.so  
cp -f lprng_init_auto_32  lprng_init_auto
cp -f ls11cloud_config_32 ls11cloud_config
cp -f p11conf_32          p11conf          

if [ "$1" -eq "64 " ]
    then 
	a=LINUX64_WRAP664
	cp -f libls11cloud_64.so  libls11cloud.so
	cp -f lprng_init_auto_64  lprng_init_auto
	cp -f ls11cloud_config_64 ls11cloud_config
	cp -f p11conf_64          p11conf          
	../../WRAP_MAC/tclexecomp64_v.1.0.3 guils11cloud_conf.tcl `cat LIST_UTIL_X86_64.txt` logo_cloud.png -forcewrap -w ../../WRAP_MAC/tclexecomp64_v.1.0.3.linux -o guils11cloud_conf_linux_v1.0.3
fi
echo $a

../../freewrap guils11cloud_conf.tcl `cat LIST_UTIL_X86_64.txt` logo_cloud.png  -w ../../$a/freewrap -o guils11cloud_conf_linux$1
chmod 755 guils11cloud_conf_linux$1
rm -f libls11cloud.so
rm -f lprng_init_auto
rm -f ls11cloud_config
rm -f p11conf
