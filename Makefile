#Makefile

VYATTA_OP = vyatta-op/templates/show/interfaces/vxlan
VYATTA_CFG_INTERFACE = vyatta-cfg/templates/interfaces/vxlan
VYATTA_CFG_PROTOCOL = vyatta-cfg/templates/protocols/vxlan
VYATTA_DST = /opt/vyatta/share
VYATTA_INTERFACE_PM = /opt/vyatta/share/perl5/Vyatta/Interface.pm
VYATTA_INTERFACE_PM_PATCH = Interface.pm.2012091101.patch

.PHONY: all
all : 
        echo "make [install|uninstall]"

install : $(PROGNAME)
        make -C vxlan 
        make -C vxlan install

        cp -r vyatta-cfg $(VYATTA_DST)/
        cp -r vyatta-op $(VYATTA_DST)/
        patch $(VYATTA_INTERFACE_PM) < patch/$(VYATTA_INTERFACE_PM_PATCH) 


uninstall : $(PROGNAME)
        make -C vxlan uninstall
        make -C vxlan clean

        rm -r $(VYATTA_DST)/$(VYATTA_OP)
        rm -r $(VYATTA_DST)/$(VYATTA_CFG_INTERFACE)
        rm -r $(VYATTA_DST)/$(VYATTA_CFG_PROTOCOL)

        patch -R $(VYATTA_INTERFACE_PM) < patch/$(VYATTA_INTERFACE_PM_PATCH) 
