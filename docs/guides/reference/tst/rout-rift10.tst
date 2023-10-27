description rift with bfd

addrouter r1
int eth1 eth 0000.0000.1111 $1a$ $1b$
int eth2 eth 0000.0000.1111 $2a$ $2b$
!
vrf def v1
 rd 1:1
 exit
router rift4 1
 vrf v1
 router 41
 red conn
 exit
router rift6 1
 vrf v1
 router 61
 red conn
 exit
int lo1
 vrf for v1
 ipv4 addr 2.2.2.1 255.255.255.255
 ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.1 255.255.255.252
 ipv4 bfd 100 100 3
 router rift4 1 ena
 router rift4 1 bfd
 ipv6 addr 1234:1::1 ffff:ffff::
 ipv6 bfd 100 100 3
 router rift6 1 ena
 router rift6 1 bfd
 exit
int eth2
 vrf for v1
 ipv4 addr 1.1.1.5 255.255.255.252
 ipv4 bfd 100 100 3
 router rift4 1 ena
 router rift4 1 bfd
 router rift4 1 metric 100
 ipv6 addr 1234:2::1 ffff:ffff::
 ipv6 bfd 100 100 3
 router rift6 1 ena
 router rift6 1 bfd
 router rift6 1 metric 100
 exit
!

addrouter r2
int eth1 eth 0000.0000.2222 $1b$ $1a$
int eth2 eth 0000.0000.2222 $2b$ $2a$
!
vrf def v1
 rd 1:1
 exit
router rift4 1
 vrf v1
 router 42
 red conn
 exit
router rift6 1
 vrf v1
 router 62
 red conn
 exit
int lo1
 vrf for v1
 ipv4 addr 2.2.2.2 255.255.255.255
 ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.2 255.255.255.252
 ipv4 bfd 100 100 3
 router rift4 1 ena
 router rift4 1 bfd
 ipv6 addr 1234:1::2 ffff:ffff::
 ipv6 bfd 100 100 3
 router rift6 1 ena
 router rift6 1 bfd
 exit
int eth2
 vrf for v1
 ipv4 addr 1.1.1.6 255.255.255.252
 ipv4 bfd 100 100 3
 router rift4 1 ena
 router rift4 1 bfd
 router rift4 1 metric 100
 ipv6 addr 1234:2::2 ffff:ffff::
 ipv6 bfd 100 100 3
 router rift6 1 ena
 router rift6 1 bfd
 router rift6 1 metric 100
 exit
!




r1 tping 100 40 2.2.2.2 vrf v1
r1 tping 100 40 4321::2 vrf v1
r2 tping 100 40 2.2.2.1 vrf v1
r2 tping 100 40 4321::1 vrf v1

sleep 3000

r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
r1 tping 100 5 4321::2 vrf v1 sou lo0
r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
r2 tping 100 5 4321::1 vrf v1 sou lo0

r2 send conf t
r2 send int eth1
r2 send shut
r2 send end

r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
r1 tping 100 5 4321::2 vrf v1 sou lo0
r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
r2 tping 100 5 4321::1 vrf v1 sou lo0

r2 output show ipv4 rift 1 nei
r2 output show ipv6 rift 1 nei
r2 output show ipv4 rift 1 dat
r2 output show ipv6 rift 1 dat
r2 output show ipv4 rift 1 tre n
r2 output show ipv6 rift 1 tre n
r2 output show ipv4 route v1
r2 output show ipv6 route v1