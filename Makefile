#Makefile

VYATTA_OP = vyatta-op/templates/show/interfaces/vxlan
VYATTA_CFG_INTERFACE = vyatta-cfg/templates/interfaces/vxlan
VYATTA_CFG_PROTOCOL = vyatta-cfg/templates/protocols/vxlan
VYATTA_DST = /opt/vyatta/share
VYATTA_INTERFACE_PM = /opt/vyatta/share/perl5/Vyatta/Interface.pm
VYATTA_INTERFACE_PM_PATCH = Interface.pm.2012110301.patch

VYATTA_VERSION_FILE = /opt/vyatta/etc/version

.PHONY: all
all : 
	make -C vxlan 

install : $(PROGNAME)
	make -C vxlan 
	make -C vxlan install

	cp -r vyatta-cfg $(VYATTA_DST)/
	cp -r vyatta-op $(VYATTA_DST)/

	if [ "`egrep 'VC6.4|oxnard' $(VYATTA_VERSION_FILE)`" != "" ]; then\
		patch $(VYATTA_INTERFACE_PM) < patch/$(VYATTA_INTERFACE_PM_PATCH);\
	elif [ "`egrep 'VC6.5|pacifica' $(VYATTA_VERSION_FILE)`" != "" ]; then\
		cp patch/vxlan_interface /opt/vyatta/etc/netdevice.d/;\
	fi


uninstall :
	make -C vxlan uninstall
	make -C vxlan clean

	rm -r $(VYATTA_DST)/$(VYATTA_OP)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_INTERFACE)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_PROTOCOL)

	if [ "`egrep 'VC6.4|oxnard' $(VYATTA_VERSION_FILE)`" != '' ]; then\
		patch -R $(VYATTA_INTERFACE_PM) < patch/$(VYATTA_INTERFACE_PM_PATCH);\
	elif [ "`egrep 'VC6.5|pacifica' $(VYATTA_VERSION_FILE)`" != '' ]; then\
		rm /opt/vyatta/etc/netdevice.d/vxlan_interface;\
	fi


