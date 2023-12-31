description bridge port split horizon

addrouter r1
int eth1 eth 0000.0000.1111 $1a$ $1b$
!
vrf def v1
 rd 1:1
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.1 255.255.255.0
 ipv6 addr 1234::1 ffff::
 exit
!

addrouter r2
int eth1 eth 0000.0000.2222 $1b$ $1a$
int eth2 eth 0000.0000.2222 $2a$ $2b$
int eth3 eth 0000.0000.2222 $3a$ $3b$
int eth4 eth 0000.0000.2222 $4a$ $4b$
!
vrf def v1
 rd 1:1
 exit
bridge 1
 mac-learn
 exit
int eth1
 bridge-gr 1
 bridge-fi private
 exit
int eth2
 bridge-gr 1
 bridge-fi private
 exit
int eth3
 bridge-gr 1
 exit
int eth4
 bridge-gr 1
 exit
int bvi1
 vrf for v1
 ipv4 addr 1.1.1.2 255.255.255.0
 ipv6 addr 1234::2 ffff::
 exit
!

addrouter r3
int eth1 eth 0000.0000.4444 $2b$ $2a$
!
vrf def v1
 rd 1:1
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.3 255.255.255.0
 ipv6 addr 1234::3 ffff::
 exit
!

addrouter r4
int eth1 eth 0000.0000.5555 $3b$ $3a$
!
vrf def v1
 rd 1:1
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.4 255.255.255.0
 ipv6 addr 1234::4 ffff::
 exit
!

addrouter r5
int eth1 eth 0000.0000.6666 $4b$ $4a$
!
vrf def v1
 rd 1:1
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.5 255.255.255.0
 ipv6 addr 1234::5 ffff::
 exit
!


r2 tping 100 5 1.1.1.1 vrf v1
r2 tping 100 5 1.1.1.3 vrf v1
r2 tping 100 5 1.1.1.4 vrf v1
r2 tping 100 5 1.1.1.5 vrf v1
r2 tping 100 5 1234::1 vrf v1
r2 tping 100 5 1234::3 vrf v1
r2 tping 100 5 1234::4 vrf v1
r2 tping 100 5 1234::5 vrf v1

r1 tping 100 5 1.1.1.2 vrf v1
r1 tping 0 5 1.1.1.3 vrf v1
r1 tping 0 5 1.1.1.4 vrf v1
r1 tping 0 5 1.1.1.5 vrf v1
r1 tping 100 5 1234::2 vrf v1
r1 tping 0 5 1234::3 vrf v1
r1 tping 0 5 1234::4 vrf v1
r1 tping 0 5 1234::5 vrf v1

r3 tping 100 5 1.1.1.2 vrf v1
r3 tping 0 5 1.1.1.1 vrf v1
r3 tping 0 5 1.1.1.4 vrf v1
r3 tping 0 5 1.1.1.5 vrf v1
r3 tping 100 5 1234::2 vrf v1
r3 tping 0 5 1234::1 vrf v1
r3 tping 0 5 1234::4 vrf v1
r3 tping 0 5 1234::5 vrf v1

r4 tping 0 5 1.1.1.1 vrf v1
r4 tping 100 5 1.1.1.2 vrf v1
r4 tping 0 5 1.1.1.3 vrf v1
r4 tping 100 5 1.1.1.5 vrf v1
r4 tping 0 5 1234::1 vrf v1
r4 tping 100 5 1234::2 vrf v1
r4 tping 0 5 1234::3 vrf v1
r4 tping 100 5 1234::5 vrf v1

r5 tping 0 5 1.1.1.1 vrf v1
r5 tping 100 5 1.1.1.2 vrf v1
r5 tping 0 5 1.1.1.3 vrf v1
r5 tping 100 5 1.1.1.4 vrf v1
r5 tping 0 5 1234::1 vrf v1
r5 tping 100 5 1234::2 vrf v1
r5 tping 0 5 1234::3 vrf v1
r5 tping 100 5 1234::4 vrf v1
