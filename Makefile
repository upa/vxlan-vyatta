# Makefile
# LOGGING_FDB_CAHNGE is work on wide camp 1203 only

CC = gcc -Wall -g 

MODULES = error.o fdb.o iftap.o net.o vxlan.o control.o
PROGNAME = vxland vxlanctl
INITSCRIPT = vxlan
INSTALLDST = /usr/local/sbin/
RCDST = /etc/init.d/
UPDATERCD = /usr/sbin/update-rc.d


VYATTA_OP = vyatta-op/templates/show/interfaces/vxlan
VYATTA_CFG_INTERFACE = vyatta-cfg/templates/interfaces/vxlan
VYATTA_CFG_PROTOCOL = vyatta-cfg/templates/protocols/vxlan
VYATTA_DST = /opt/vyatta/share
VYATTA_PERLLIBDIR = /opt/vyatta/share/perl5/Vyatta
VYATTA_INTERFACE_PM_PATH = Interface.pm.2012091101.patch


.PHONY : all
all : vxland vxlanctl

.c.o:
	$(CC) -c $< -o $@

modules : $(MODULES)

vxland : main.c common.h $(MODULES)
	$(CC) -pthread main.c $(MODULES) -o vxland

vxlanctl : vxlanctl.c common.h
	$(CC) vxlanctl.c -o vxlanctl

clean :
	rm $(MODULES) $(PROGNAME)

install	: $(PROGNAME)
	install vxland $(INSTALLDST)
	install vxlanctl $(INSTALLDST)
	install $(INITSCRIPT) $(RCDST)
	$(UPDATERCD) $(INITSCRIPT) defaults

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
	rm $(INSTALLDST)/vxland
	rm $(INSTALLDST)/vxlanctl
	$(UPDATERCD) -f $(INITSCRIPT) remove
	rm $(RCDST)/$(INITSCRIPT)

	rm -r $(VYATTA_DST)/$(VYATTA_OP)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_INTERFACE)
	rm -r $(VYATTA_DST)/$(VYATTA_CFG_PROTOCOL)

	pushd .
	cp patch/$(VYATTA_INTERFACE_PM_PATCH) ${VYATTA_PERLLIBDIR}/
	cd $(VYATTA_PERLLIBDIR)
	patch -R < ${VYATTA_INTERFACE_PM_PATCH}
	rm ${VYATTA_INTERFACE_PM_PATCH}
	popd .



control.c	: control.h
error.c		: error.h
fdb.c		: fdb.h
iftap.c		: iftap.h
net.h		: common.h
net.c		: net.h fdb.h error.h sockaddrmacro.h
vxlan.h		: common.h
vxlan.c		: net.h fdb.h error.h vxlan.h iftap.h sockaddrmacro.h

