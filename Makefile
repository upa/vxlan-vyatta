# Makefile

VYATTA_OP = vyatta-op/templates/show/interfaces/vxlan
VYATTA_CFG_INTERFACE = vyatta-cfg/templates/interfaces/vxlan
VYATTA_CFG_PROTOCOL = vyatta-cfg/templates/protocols/vxlan
VYATTA_DST = /opt/vyatta/share
VYATTA_PERLLIBDIR = /opt/vyatta/share/perl5/Vyatta
VYATTA_INTERFACE_PM_PATH = Interface.pm.2012091101.patch


install	: $(PROGNAME)
	make -C vxlan 
	make -C vxlan install

	install -D $(VYATTA_OP)/* $(VYATTA_DST)/$(VYATTA_OP)
	install -D $(VYATTA_CFG_INTERFACE)/* $(VYATTA_DST)/$(VYATTA_CFG_INTERFACE)
	install -D $(VYATTA_CFG_PROTOCOL)/* $(VYATTA_DST)/$(VYATTA_CFG_PROTOCOL)

	pushd .
	cp patch/$(VYATTA_INTERFACE_PM_PATCH) ${VYATTA_PERLLIBDIR}/
	cd $(VYATTA_PERLLIBDIR)
	patch < ${VYATTA_INTERFACE_PM_PATCH}
	rm ${VYATTA_INTERFACE_PM_PATCH}
	popd .



uninstall : $(PROGNAME)
	make -C vxlan uninstall
	make -C vxlan clean

	rm -r $(VYATTA_DST)/$(VYATTA_OP)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_INTERFACE)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_PROTOCOL)

	pushd .
	cp patch/$(VYATTA_INTERFACE_PM_PATCH) ${VYATTA_PERLLIBDIR}/
	cd $(VYATTA_PERLLIBDIR)
	patch -R < ${VYATTA_INTERFACE_PM_PATCH}
	rm ${VYATTA_INTERFACE_PM_PATCH}
	popd .

