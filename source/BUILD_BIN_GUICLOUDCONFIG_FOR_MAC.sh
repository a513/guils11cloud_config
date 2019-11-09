echo "usage: ./BUILD_BIN_GUICLOUDCONFIG_FOR_MAC.sh"
#	cp -f libls11cloud_64.dylib  libls11cloud.so  
	cp -f lprng_init_auto_mac  lprng_init_auto
	cp -f ls11cloud_config_mac ls11cloud_config
	cp -f p11conf_mac          p11conf          

../../WRAP_MAC/tclexecomp64_v.1.0.3 guils11cloud_conf.tcl libls11cloud.dylib lprng_init_auto ls11cloud_config p11conf logo_cloud.png  -forcewrap -w  ../../WRAP_MAC/tclexecomp64.mac_v.1.0.3 -o guils11cloud_conf_mac
chmod 755  guils11cloud_conf_mac
rm -f lprng_init_auto
rm -f ls11cloud_config
rm -f p11conf

exit
