description qos egress drop action

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
!
vrf def v1
 rd 1:1
 exit
policy-map p1
 seq 10 act drop
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.2 255.255.255.0
 ipv6 addr 1234::2 ffff::
 service-policy-out p1
 exit
!



r2 tping 0 5 1.1.1.1 vrf v1 siz 200
r2 tping 0 5 1234::1 vrf v1 siz 200
r1 tping 0 5 1.1.1.2 vrf v1 siz 200
r1 tping 0 5 1234::2 vrf v1 siz 200