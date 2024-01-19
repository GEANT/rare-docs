description interop2: lacp

addrouter r1
int eth1 eth 0000.0000.1111 $per1$
!
vrf def v1
 rd 1:1
 exit
int eth1
 lacp 0000.0000.1111 123 12345
 vrf for v1
 ipv4 addr 1.1.1.1 255.255.255.0
 ipv6 addr 1234::1 ffff::
 exit
!

addpersist r2
int eth1 eth 0000.0000.2222 $per1$
!
interface bundle-ether1
 ipv4 address 1.1.1.2 255.255.255.0
 ipv6 address 1234::2/64
 no shutdown
 exit
interface gigabit0/0/0/0
 bundle id 1 mode active
 lacp period short
 no shutdown
 exit
root
commit
!


r1 tping 100 10 1.1.1.2 vrf v1
r1 tping 100 10 1234::2 vrf v1