# Example: bgp interas csc vpn with asbr peering

=== "Topology"

    ![Alt text](../d2/rout-bgp335/rout-bgp335.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.0
     pseudo v2 lo1 pweompls 3.3.3.6 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 5.5.5.1 255.255.255.0
     pseudo v2 lo1 pweompls 3333::6 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.2 255.255.255.255
     ipv6 addr 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     neigh 2.2.2.1 route-reflect
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     neigh 2.2.2.3 send-comm both
     neigh 2.2.2.3 route-reflect
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.2
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     neigh 4321::1 route-reflect
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     neigh 4321::3 send-comm both
     neigh 4321::3 route-reflect
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 1.1.1.10 255.255.255.255 1.1.1.10 mplsimp
    ipv6 route v1 1234:3::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2 mplsimp
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 2
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.3
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 2
     exit
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.10 remote-as 2
     neigh 1.1.1.10 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.3
     neigh 1234:3::2 remote-as 2
     neigh 1234:3::2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 1
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.4 255.255.255.255
     ipv6 addr 3333::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.5 255.255.255.255 1.1.1.14
    ipv6 route v1 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    ipv4 route v1 2.2.2.6 255.255.255.255 1.1.1.14
    ipv6 route v1 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    ipv4 route v1 1.1.1.9 255.255.255.255 1.1.1.9 mplsimp
    ipv6 route v1 1234:3::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1 mplsimp
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.4
     neigh 2.2.2.5 remote-as 2
     neigh 2.2.2.5 update lo0
     neigh 2.2.2.5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.4
     neigh 4321::5 remote-as 2
     neigh 4321::5 update lo0
     neigh 4321::5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 1
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.3
     neigh 1.1.1.9 remote-as 1
     neigh 1.1.1.9 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 2
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.3
     neigh 1234:3::1 remote-as 1
     neigh 1234:3::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 2
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.5 255.255.255.255
     ipv6 addr 3333::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.17 255.255.255.252
     ipv6 addr 1234:5::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.13
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv4 route v1 2.2.2.6 255.255.255.255 1.1.1.18
    ipv6 route v1 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::2
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.5
     neigh 2.2.2.4 remote-as 2
     neigh 2.2.2.4 update lo0
     neigh 2.2.2.4 send-comm both
     neigh 2.2.2.4 route-reflect
     neigh 2.2.2.6 remote-as 2
     neigh 2.2.2.6 update lo0
     neigh 2.2.2.6 send-comm both
     neigh 2.2.2.6 route-reflect
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.5
     neigh 4321::4 remote-as 2
     neigh 4321::4 update lo0
     neigh 4321::4 send-comm both
     neigh 4321::4 route-reflect
     neigh 4321::6 remote-as 2
     neigh 4321::6 update lo0
     neigh 4321::6 send-comm both
     neigh 4321::6 route-reflect
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.255
     ipv6 addr 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.6 255.255.255.255
     ipv6 addr 3333::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.18 255.255.255.252
     ipv6 addr 1234:5::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.17
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::1
    ipv4 route v1 2.2.2.5 255.255.255.255 1.1.1.17
    ipv6 route v1 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::1
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.6
     neigh 2.2.2.5 remote-as 2
     neigh 2.2.2.5 update lo0
     neigh 2.2.2.5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.6
     neigh 4321::5 remote-as 2
     neigh 4321::5 update lo0
     neigh 4321::5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 4.4.4.6 255.255.255.0
     pseudo v2 lo1 pweompls 3.3.3.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 5.5.5.6 255.255.255.0
     pseudo v2 lo1 pweompls 3333::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.5 vrf v1 sou lo0
    r4 tping 100 60 4321::5 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r4 tping 100 60 4321::6 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r5 tping 100 60 4321::4 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r5 tping 100 60 4321::6 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r6 tping 100 60 4321::4 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.5 vrf v1 sou lo0
    r6 tping 100 60 4321::5 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v2 sou lo1
    r1 tping 100 60 3333::2 vrf v2 sou lo1
    r1 tping 100 60 3.3.3.3 vrf v2 sou lo1
    r1 tping 100 60 3333::3 vrf v2 sou lo1
    r2 tping 100 60 3.3.3.1 vrf v2 sou lo1
    r2 tping 100 60 3333::1 vrf v2 sou lo1
    r2 tping 100 60 3.3.3.3 vrf v2 sou lo1
    r2 tping 100 60 3333::3 vrf v2 sou lo1
    r3 tping 100 60 3.3.3.1 vrf v2 sou lo1
    r3 tping 100 60 3333::1 vrf v2 sou lo1
    r3 tping 100 60 3.3.3.2 vrf v2 sou lo1
    r3 tping 100 60 3333::2 vrf v2 sou lo1
    r4 tping 100 60 3.3.3.5 vrf v2 sou lo1
    r4 tping 100 60 3333::5 vrf v2 sou lo1
    r4 tping 100 60 3.3.3.6 vrf v2 sou lo1
    r4 tping 100 60 3333::6 vrf v2 sou lo1
    r5 tping 100 60 3.3.3.4 vrf v2 sou lo1
    r5 tping 100 60 3333::4 vrf v2 sou lo1
    r5 tping 100 60 3.3.3.6 vrf v2 sou lo1
    r5 tping 100 60 3333::6 vrf v2 sou lo1
    r6 tping 100 60 3.3.3.4 vrf v2 sou lo1
    r6 tping 100 60 3333::4 vrf v2 sou lo1
    r6 tping 100 60 3.3.3.5 vrf v2 sou lo1
    r6 tping 100 60 3333::5 vrf v2 sou lo1
    r4 tping 100 60 3.3.3.1 vrf v2 sou lo1
    r4 tping 100 60 3333::1 vrf v2 sou lo1
    r4 tping 100 60 3.3.3.2 vrf v2 sou lo1
    r4 tping 100 60 3333::2 vrf v2 sou lo1
    r4 tping 100 60 3.3.3.3 vrf v2 sou lo1
    r4 tping 100 60 3333::3 vrf v2 sou lo1
    r5 tping 100 60 3.3.3.1 vrf v2 sou lo1
    r5 tping 100 60 3333::1 vrf v2 sou lo1
    r5 tping 100 60 3.3.3.2 vrf v2 sou lo1
    r5 tping 100 60 3333::2 vrf v2 sou lo1
    r5 tping 100 60 3.3.3.3 vrf v2 sou lo1
    r5 tping 100 60 3333::3 vrf v2 sou lo1
    r6 tping 100 60 3.3.3.1 vrf v2 sou lo1
    r6 tping 100 60 3333::1 vrf v2 sou lo1
    r6 tping 100 60 3.3.3.2 vrf v2 sou lo1
    r6 tping 100 60 3333::2 vrf v2 sou lo1
    r6 tping 100 60 3.3.3.3 vrf v2 sou lo1
    r6 tping 100 60 3333::3 vrf v2 sou lo1
    r1 tping 100 60 3.3.3.4 vrf v2 sou lo1
    r1 tping 100 60 3333::4 vrf v2 sou lo1
    r1 tping 100 60 3.3.3.5 vrf v2 sou lo1
    r1 tping 100 60 3333::5 vrf v2 sou lo1
    r1 tping 100 60 3.3.3.6 vrf v2 sou lo1
    r1 tping 100 60 3333::6 vrf v2 sou lo1
    r2 tping 100 60 3.3.3.4 vrf v2 sou lo1
    r2 tping 100 60 3333::4 vrf v2 sou lo1
    r2 tping 100 60 3.3.3.5 vrf v2 sou lo1
    r2 tping 100 60 3333::5 vrf v2 sou lo1
    r2 tping 100 60 3.3.3.6 vrf v2 sou lo1
    r2 tping 100 60 3333::6 vrf v2 sou lo1
    r3 tping 100 60 3.3.3.4 vrf v2 sou lo1
    r3 tping 100 60 3333::4 vrf v2 sou lo1
    r3 tping 100 60 3.3.3.5 vrf v2 sou lo1
    r3 tping 100 60 3333::5 vrf v2 sou lo1
    r3 tping 100 60 3.3.3.6 vrf v2 sou lo1
    r3 tping 100 60 3333::6 vrf v2 sou lo1
    r1 tping 100 60 4.4.4.6 vrf v1
    r6 tping 100 60 4.4.4.1 vrf v1
    r1 tping 100 60 5.5.5.6 vrf v1
    r6 tping 100 60 5.5.5.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp335](../clab/rout-bgp335/rout-bgp335.yml) file  
        3. Launch ContainerLab `rout-bgp335.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp335.yml  
        ```
        4. Destroy ContainerLab `rout-bgp335.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp335.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp335.tst` file [here](../tst/rout-bgp335.tst)  
        3. Launch `rout-bgp335.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp335 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp335.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

