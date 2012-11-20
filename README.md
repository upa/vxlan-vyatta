vxlan-vyatta
============

vxlan-vyatta is vxlan module for vyatta. It enables that you can use
vxlan through vyatta. This vxlan implementation is based on
http://github.com/upa/vxlan (vxlan implementation on linux Userland).


vxlan-vyatta can be used on VC6.4 oxnard and VC6.5 pacifica.


Install
-------
vxlan-vyatta requires vyatta to be installed gcc, make and git before 
installing this application.

	 
	 % git clone git://github.com/upa/vxlan-vyatta.git
	 % cd vxlan-vyatta
	 % make install

#### Fatal 
In VC6.4, vxlan-vyatta applies vxlan extention patch to 
/opt/vyatta/share/perl5/Vyatta/Interface.pm . This patch will be removed 
when you will uninstall vxlan-vyatta.
	  

Uninstall
---------
	 % make uninstall


How to use vxlan through Vyatta
-------------------------------
vyatta installed vxlan-vyatta provides vxlan configuration command in term of 
_protocols vxlan_ and _interface vxlan_ .

	 vyatta@vyatta:~$ configure
 	 [edit]
	 vyatta@vyatta# edit protocols vxlan 

At 1st, you shoud configure _multicast-address_ and
_multicast-interface_ .  Default Multicast address is 239.0.0.1, and
vxlan does not select multicast interface if you don't specify the
_multicast-interface_. 

	 vyatta@vyatta# set multicast-address 239.0.0.100
	 [edit protocols vxlan]
	 vyatta@vyatta# set multicast-interface eth1
	 [edit protocols vxlan]
	 vyatta@vyatta# show
	 +multicast-address 239.0.0.1
	 +multicast-interface eth1
	 [edit protocols vxlan]
	 vyatta@vyatta#

2nd, you configure VNI (Virtual Network Identifier). 

	 [edit protocols vxlan]
	 vyatta@vyatta# set vni 0
	 [edit protocols vxlan]
	 vyatta@vyatta# set vni  1
	 [edit protocols vxlan]
	 vyatta@vyatta# top
	 [edit]
 	 vyatta@vyatta# show protocols
	 +vxlan {
	 +    multicast-address 239.0.0.1
	 +    multicast-interface eth1
 	 +    vni 0
	 +    vni 1
	 +}
	 [edit]
	 vyatta@vyatta# commit


vxlan-vyatta creates tap interface that is named vxlan[VNI]. 
And You can use vxlan interface like ethernet interface.


ToDo
----
- Create deb package
- IPv6 Multicast Address
- Kernel Module (?)


Contact
-------
upa@haeena.net


